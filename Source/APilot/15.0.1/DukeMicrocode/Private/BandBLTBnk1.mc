{	File name: BandBLTBnk1.mc	Description: Mesa byte-code to convert bandlist entries to bits in a bandbuffer	Author: Patrick PXO     	Created: June 10, 1980  2:48 PM	LOG	SxO/TxH	    13-Sep-88  9:23:20 added TheNumberOfBanks instead of thereAreTwoBanks and moved to bank1 for Duke. changed file name	TXM     ,   6-Jun-88  9:24:10: Moved to bank2 for Duke	CRF     ,  26-Oct-86 12:24:20: Added comments; changed loop exit test in InterpolatorLoop to subtraction from xor for readability; use symbolic constant for trapezoid item length; Nooped unnecessary instruction preceding InterpolatorLoop; replaced uRect* and uChar* by uLO*.	CRF     ,   1-Aug-86 12:02:45: Added trapezoid support; deleted remains	of old bitmap band list entry code.	RDH     ,  13-Nov-85 15:07:18: Correct setting of USrcBpl to be bits not words.	RDH     ,  30-Oct-85 12:14:18: Change for integration with workstation uCode (U reg defs changed a lot to avoid collision with TextBlt).	Dennis DEG     ,   1-Sep-84 19:07:43: Add copyright notice.	AeF AEF     ,  18-Nov-83 11:22:39: Added click to Rectangle and Character because of register conflict with Xfer.	AXD    ,  16-Aug-83 13:49:04: RRot1 uPPMask because of new PSB format.	AeF AEF     ,   2-Aug-83 16:35:44: Change at NoCross3+1 for 32-bit comtrol links changes.	Jim JXF     ,  February 11, 1981  11:05 AM: use symbol to call SavebbRegs.	PXO     ,  March 19, 1981  8:55 PM:  total re-work of levels, inks, and leftovers.	PXO     ,  March 23, 1981  4:17 PM:  Changed spellings of all occurrences of "uregMumble" to "uMumble."	PXO     ,  April 20, 1981  5:35 PM:  Change a "reReadRets" to  "ReadRets."	PXO     ,  April 21, 1981  4:48 PM:  Fix comparison when deciding whether to switch lists on finding SetLevel bandlist entry.	Jim JXF     ,  August 20, 1981  3:47 PM: changes for new assembler.	JGS    ,  November 16, 1981  12:17 PM: new instruction set.	CRF, July 6, 1982  3:04 PM: pass source WORDS per line instead of BITS per	line to BandBLTBBInit; skip objects starting beyond the scan line end.	CRF, 8-Oct-82  9:27:05: restore uVirtPage when skipping objects beyond the	scan line end.}{ 	Copyright (C) 1980, 1981, 1982, 1983 by Xerox Corporation.  All rights reserved.}@BandBLT:	ULsave � L, L2 � Savebb.BANDBLT,	c1, at[addrBandBLT];{	Save R and RH registers.}	rhType � Type.LSEP{For BITBLT}, CALL[SavebbRegs]	,c2;	{SavebbRegs subroutine here for 2-2/3 clicks	,c3-c1;}{	SavebbRegs returns to BitBlt code that checks the stack size to	determine whether we're returning from an interrupt.  If so, control	either stays with BitBlt, if it was interrupted, or comes back to	TrapezoidBLTInt below if TrapezoidBLT was interrupted.  If we're not	returning from either interrupt, this is a normal entry to BandBLT, and	control resumes at NormalEntry below.		BandBLT trapezoids are only implemented on Daybreaks with two banks of	control store.  In the single bank case, BandBLT trapezoids are treated	as NOPs, so we'll never be returning from a fault or interrupt in	TrapezoidBLT.}{IfEqual[thereAreTwoBanks,0,SkipTo[NoTrapezoids],];}IfGreater[3,TheNumberOfBanks,SkipTo[NoTrapezoids],];TrapezoidBLTInt:	{TrapezoidBLT is in the other control store bank, so switch banks.}	Noop					,c1, at[hbs.E,10,HowBigStack];	Bank � bank2{Bank � bank1}		,c2;	Noop, GOTOBANK2[BandBLTIntEntry],{GOTOBANK1[BandBLTIntEntry]}	,c3;NoTrapezoids!{	The top stack entry is an MDS-relative pointer to the parameter block for this byte-code; we first fetch the parameters into	U-registers.  The parameters wind up butted up against the high end of a 16-member bank of U-regs, i.e., in registers ...C, D,	E, F (MOD 10).  The exception is the last parameter word, which is left in an R-register and never stored into a U-register; thus	we have parameter words 1 through n-1 loaded into U-registers as follows:	Parameter Word	U-reg address (MOD 10)	1	F - (n - 2)	2	F - (n - 3)	3	F - (n - 4)	...	...	n-3	F - 2	n-2	F - 1	n-1	F	n	not stored}{-----------------------------------------------------------------------------------------------------------------------------------------------------------------	This call to Read will translate the parameter block virtual address to real, leaving the result in rhReadP,,rReadP, and return the	first word of the block in rTemp, in preparation for the loop below which loads the parameter blocks into U-registers.}NormalEntry:	rUindex � Arg0, push, pCall2	,c1, at[hbs.1, 10, HowBigStack];	rReadV � STK, fXpop, fZpop	,c2, at[Read.0, 10];	rhReadV � TOS LRot0{rhMDS}, CALL[Read]	,c3;{-----------------------------------------------------------------------------------------------------------------------------------------------------------------	This loop loads the parameters from memory into the U-registers; note that the U-register is loaded with the contents of the	R-register rTemp, which holds the word fetched in the previous pass through the loop. This is why the last parameter word	ends up not getting stored in a U-register (see the code at label suDone).}suLoop:	rReadP � MAR � [rhReadP, rReadP + 1]	,c1, at[Read.0, 10, ReadRets];	Ybus � rUindex, rUindex � rUindex + 1, AltUaddr, NibCarryBr, CancelPgCross[$]	,c2;	uyBlk � rTemp, rTemp � MD, BRANCH[suLoop, suDone]	,c3;{	End of parameter loop.  Leave last parameter word in rTemp for subroutine PageNumToPtr.  This code assumes that the last	parameter word is the page number of the caller's inkwells.}suDone:	rScratch � RRot1 uPPMask{7000:  forward, disjoint, disjointItems, gray, null, null}, pCall2{last parameter word (rTemp) is ink page #}	,c1, at[Read.1, 10, suLoop];{-----------------------------------------------------------------------------------------------------------------------------------------------------------------	Save the virtual address of the caller's gray blocks ("inkwells").  This page contains inkwells at 0-MOD-10 addresses.  We	convert the virtual page number to a LONG POINTER and store it in uInkHigh,,uInkLow.  Note that only the low 8 bits of	uInkHigh are valid; this U-register will later be loaded into an RH-register.	We also zero the stack pointer here.  The reason for this is as follows:  When BandBLT returns, it leaves a LONG POINTER on the	stack; this pointer is either the address of the end-of-band entry causing the return or , in the case of end-of-band, NIL.  Thus the	stack pointer must be set to 2.  The problem is that it's very hard to fit "stackP � 2" into the return sequence code, whereas two	"pushes" fit nicely.  This only works, however, if the stack pointer is known to be zero.  BITBLT zeroes the stack pointer, but there	is no guarantee that a call to BandBLT will ever call BITBLT.  Note also that this code assumes that BITBLT can handle being called	with stackP equal to zero.}	uCurrentFlags � rScratch{7000}, stackP � rScratch{0: low nybble of 7000}, CALL[PageNumToPtr]	,c2, at[PageNumToPtr.0, 10];	uInkHigh � rTemp	,c2, at[PageNumToPtr.0, 10, PageNumToPtrRets];	uInkLow � rJunk, pCall2	,c3;{-----------------------------------------------------------------------------------------------------------------------------------------------------------------	This code takes the input parameter uBitmapMemPage, the virtual page number of the memory containing	the font rasters (as opposed to the font pointers and font displacements), and saves it as a LONG POINTER (virtual)	in uBitmapMemHigh,,uBitmapMemLow.  Subsequently, when processing characters, this address will be indexed	by a character's font displacement value to find the appropriate rasters.  Note that only the low 8 bits of uBitmapMemHigh	are valid; this U-register will later be loaded into an RH-register.}	rTemp � uBitmapMemPage, CALL[PageNumToPtr]	,c1, at[PageNumToPtr.1, 10];	uBitmapMemHigh � rTemp	,c1, at[PageNumToPtr.1, 10, PageNumToPtrRets];	uBitmapMemLow � rJunk, pCall2	,c2;{-----------------------------------------------------------------------------------------------------------------------------------------------------------------	This call to reRead translates the virtual page number of the Font Pointer Table (uFPTPage) to a real address,	which is stored in uFPTHigh,,uFPTLow.  Subsequently, when processing characters, this table will be indexed	by a character's Font value to find a pointer to its Font Vector Table.	This code also loads garbage into uSaveLOwritePHigh,,uSaveLOwritePLow, the pointer to	the output leftover list.  The reason for doing this is to set up for when we need to	write a leftover.  The way it's done is to take a known safe physical address (the	address of the Font Pointer Table), OR it with 0FF, and save the result in	uSaveLOwritePHigh,,uSaveLOwritePLow.  This will cause a page-cross and a remap	the first time an attempt is made to write a leftover; the virtual page number we	use then will be uLOwriteV, the output leftover list page number.}	rTemp � uFPTPage, CALL[reRead]	,c3, at[reRead.8, 10];	uFPTLow � rReadP	,c1, at[reRead.8, 10, ReadRets];{	The low 8 bits of uSaveLOwritePLow are turned on to force a page-cross and remap the very first time an attempt is made to write	a leftover list entry.}	rReadP � rReadP or 0FF	,c2;	uSaveLOwritePLow � rReadP	,c3;	rReadP � rhReadP	,c1;	uFPTHigh � rReadP	,c2;	uSaveLOwritePHigh � rReadP	,c3;	uOtherFlags � rScratch{7000:  forward, disjoint, disjointItems, gray, null, null}	,c1;{-----------------------------------------------------------------------------------------------------------------------------------------------------------------	This call to Read translates the virtual address (in uBLreadHigh,,uBLreadLow) of the input bandlist to a real address, which	is saved in uOtherListHigh,,uOtherListLow.}{L2 = 5 is used for call to Read and for call to TempRot12.}	rReadV � uBLreadLow, pCall2	,c2;	rhReadV � uBLreadHigh, CALL[Read]	,c3, at[Read.5, 10];	uOtherVirtPage � rJunk {uVirtPage}, 	,c1, at[Read.5, 10, ReadRets];	rTemp � SetInk, L2Disp, CALL[TempRot12]	,c2;	{rTemp � rTemp LRot12 {Set Ink 0, flags 0}	,c3;}	uLastInkLOwritten � rTemp{Set Ink 0, flags 0} 	,c1, at[Rot12.5, 10, Rot12Ret];	uCurrentInkCmd � rTemp{Set Ink 0, flags 0} 	,c2;	uOtherInkCmd � rTemp{Set Ink 0, flags 0} 	,c3;	uOtherListLow � rReadP	,c1;	rReadP � rhReadP	,c2;	uOtherListHigh � rReadP	,c3;	rTemp � uInkLow	,c1;	uCurrentInkwell � rTemp	,c2;	uOtherInkwell � rTemp, L2 � Rot12.2	,c3;	rTemp � SetLevel, L2Disp, CALL[TempRot12]	,c1;	{rTemp � rTemp LRot12{Set level 0} 	,c2;}	uCurrentLevelCmd � rTemp{Set level 0}, pCall2	,c3, at[Rot12.2, 10, Rot12Ret];	uOtherLevelCmd � rTemp{Set level 0}, L3 � LOlist	,c1, at[reRead.3, 10];{-----------------------------------------------------------------------------------------------------------------------------------------------------------------	At this point, we're ready to start processing the input leftover list: all the necessary housekeeping has been done, including	setting L3 to indicate that we're now in the leftover list.  (When an end-of-band is found in this list, we'll start processing the	input bandlist, and L3 will be set to indicate that.)  The call to reRead translates uLOreadV, the virtual page number of the input	leftover list, to a real address in rhReadP,,rReadP, and returns in rTemp the first word in that list.  We then decide whether that	word indicates a character, rectangle, etc., and then begin the real processing.  Switch is the label to which control is passed	when we're done handling a character, rectangle, etc., and need to read the next item in the list currently being read.}	uLastLevelLOwritten � rTemp{Set level 0}	,c2;	rTemp � uLOreadV, CALL[reRead]	,c3;{-----------------------------------------------------------------------------------------------------------------------------------------------------------------	If the sign bit is off, then this entry is a character descriptor (or a character leftover, if we're in the leftover list).  If the sign bit is on,	a dispatch is needed to determine whether the entry is a rectangle, command, etc.}Switch:	[] � rTemp, NegBr	,c1, at[reRead.3, 10, ReadRets];	Xbus � rTemp BLentryTypeRot, XDisp, BRANCH[Char, $]	,c2;	{Noop, }ListFlagDisp, BLentryDISP[EntryType]	,c3;{-----------------------------------------------------------------------------------------------------------------------------------------------------------------	End-of-page.	End-of-page command found in leftover list should probably be an error, but we'll simply clean up and return.}PageEnd:	TOS � Nil, CANCELBR[$]	,c1, at[EndOfPage, 10, EntryType];	uStack2 � Nil, pCall0	,c2;	stackP � 2, CALL[RestoreRandRHRegs]	,c3, at[restore.BandBLT, 10];{	End-of-band code also returns here from RestoreRandRHRegs.}	Noop	,c2, at[restore.BandBLT, 10, RestoreCallers];	Noop, GOTO[BBExit]	,c3;{-----------------------------------------------------------------------------------------------------------------------------------------------------------------	End-of-band -- find out which list we're in.}BandEnd:	Noop, BRANCH[eobLO, $]	,c1, at[EndOfBand, 10, EntryType];{	End-of-band command found in bandlist; save bandlist pointer for building the return value later.}	rJunk � uVirtPage	,c2;	uRetPage � rJunk	,c3;	uRetWord � rReadP, GOTO[eobLO]	,c1;eobLO:	Xbus � uOtherLevelCmd, XHDisp	,c2;	uCurrentLevelCmd � ~r0100 xor r0100, BRANCH[$, seenEob, 1]	,c3;	rTemp � rReadP, ListFlagDisp, GOTO[MoreChangeLists]	,c1;seenEob:	uLO2 � rTemp{word to be written}, pCall1	,c1;	rReadP � uRetWord{writeLO had better not touch}	,c2, at[writeLO.2, 10];	rJunk � OneWordLO{single-word leftover list entry}, CALL[writeLO]	,c3;{	Here we use uRetPage (the virtual page number saved upon finding an end-of-band while reading the bandlist) and uRetWord	(the real address used to read in the bandlist) to construct the virtual address of the last word read from the bandlist.  This is the	value returned by this byte-code.	The purpose of the two "pushes" is to set stackP to 2; stackP is known to be zero since the init sequence zeroes it, as does every	call to BITBLT.}	push, TOS � uRetPage	,c1, at[writeLO.2, 10, writeLORets];	push, TOS � TOS - 1{current virtual page number}	,c2;	rhMDS � TOS � TOS LRot8	,c3;{	This instruction sets TOS to the low 16 bits of the virtual address, getting the high byte from TOS and the low byte from rReadP.	We don't really want to read memory; we just want the side effects of the "MAR �."  The "Map �" clause is included to cause the	read to be from the Map, rather than from real memory.  This avoids reading random, possibly non-existent, real memory.  Note that	this click may be aborted and re-executed if rhMDS is zero; the processor thinks it needs to make us wait for access to the display	bank.}	TOS � MAR � Map � [rhMDS, rReadP + 0]	,c1;	STK � TOS, pCall0	,c2;	TOS � rhMDS, CALL[RestoreRandRHRegs]{Returns to the end-of-page code}	,c3, at[restore.BandBLT,  10];{-----------------------------------------------------------------------------------------------------------------------------------------------------------------}SetLevel:	rJunk � uOtherLevelCmd, CANCELBR[$]	,c1, at[SetLevel, 10, EntryType];	[] � rTemp - rJunk - 1,  PgCarryBr	,c2;	uCurrentLevelCmd � rTemp{new level cmd}, BRANCH[$, ChangeLists]	,c3;	rReadP � MAR � [rhReadP, rReadP + 1], pCall2, GOTO[GetNextWordc2]	,c1;{	This code is used to switch between the bandlist and leftover list.  It first increments rhReadP,,rReadP (remapping if necessary);	this is to avoid repeatedly reading SetLevel bandlist entries.  It then swaps rhReadP,,rReadP with uOtherListHigh,,uOtherListLow,	swaps uVirtPage with uOtherListVirtPage, swaps uCurrentInkwell with uOtherInkwell, swaps uCurrentLevelCmd with uOtherLevelCmd, swaps uCurrentInkCmd with uOtherInkCmd, swaps uCurrentFlags with uOtherFlags, and toggles L3 from LOlist <--> BL.}ChangeLists:	rReadP � rReadP + 1, PgCarryBr	,c1;	{Noop, }pCall2, BRANCH[NoCross1, $]	,c2;	rTemp � uVirtPage, CALL[reRead]	,c3, at[reRead.D, 10];NoCross1:	Noop	,c3;	rTemp � rReadP, ListFlagDisp	,c1, at[reRead.D, 10, ReadRets];MoreChangeLists:	rReadP � rhReadP, BRANCH[InLOlist, InBandList]	,c2;InBandList:	L3 � LOlist	,c3;	rhReadP � uOtherListHigh, GOTO[Contin]	,c1;InLOlist:	L3 � BL	,c3;	rhReadP � uOtherListHigh	,c1;Contin:	uOtherListHigh � rReadP	,c2;	rReadP � uOtherListLow	,c3;	uOtherListLow � rTemp	,c1;{-------}	rTemp � uCurrentInkwell	,c2;	rDest � uOtherInkwell	,c3;	uOtherInkwell � rTemp	,c1;	uCurrentInkwell � rDest	,c2;{-------}	rTemp � uCurrentLevelCmd	,c3;	rDest � uOtherLevelCmd	,c1;	uOtherLevelCmd � rTemp	,c2;	uCurrentLevelCmd � rDest	,c3;{-------}	rTemp � uCurrentInkCmd	,c1;	rDest � uOtherInkCmd	,c2;	uOtherInkCmd � rTemp	,c3;	uCurrentInkCmd � rDest	,c1;{-------}	rTemp � uCurrentFlags	,c2;	rDest � uOtherFlags	,c3;	uOtherFlags � rTemp	,c1;	uCurrentFlags � rDest	,c2;{-------}	rTemp � uVirtPage	,c3;	rDest � uOtherVirtPage	,c1;	uOtherVirtPage � rTemp	,c2;	uVirtPage � rDest	,c3;	MAR � [rhReadP, rReadP + 0], GOTO[GetNextWordc2]	,c1;{-----------------------------------------------------------------------------------------------------------------------------------------------------------------}SetInk:	uCurrentInkCmd � rTemp, CANCELBR[$]	,c1, at[SetInk, 10, EntryType];	rJunk � rTemp and 00FF{new inkwell number}	,c2;	rTemp � rTemp LRot8	,c3;	rTemp � rTemp and 0E{bitblt srcfunc,,dstfunc,,0}	,c1;	rTemp � rTemp or 70{forward(0), disjoint(1), disjointItems(1), gray(1)}	,c2;	rTemp � rTemp LRot8	,c3;	uCurrentFlags � rTemp	,c1;	rJunk � rJunk LRot4{new inkwell number * 16}	,c2;	rTemp � uInkLow	,c3;	rJunk � rJunk + rTemp{inks must all live within same 64-K virtual bank}	,c1;	uCurrentInkwell � rJunk	,c2;	Noop, GOTO[GetNextWord]	,c3;{-----------------------------------------------------------------------------------------------------------------------------------------------------------------	Rulette entry.}Roulette:	rYloc � ~000F, CANCELBR[$]	,c1, at[Roulette, 10, EntryType];	rYloc � rYloc LRot12{0FFF}	,c2;	rYloc � rTemp and rYloc	,c3;	rReadP � MAR � [rhReadP, rReadP + 1], pCall2	,c1;	uLO2 � 0{no leftover to write}, PgCrBRANCH[NoCross0, $]	,c2, at[reRead.E, 10];	rTemp � uVirtPage, CALL[reRead]	,c3;NoCross0:	rTemp � MD	,c3;{L2 = 3 is used for call to SaveReadPtr and for call to TempRot12.}	Q � rTemp and 0F {xloc}, pCall2	,c1, at[reRead.E, 10, ReadRets];	rTemp � rTemp xor Q, CALL[SaveReadPtr]	,c2, at[SaveReadPtr.3, 10];	rNlines � 1, L2Disp, CALL[TempRot12]	,c2, at[SaveReadPtr.3, 10, SaveReadPtrRets];	{rTemp � rTemp LRot12	,c3;}	UWidth � rTemp{For BITBLT}, GOTO[RectRuletteCommon]	,c1, at[Rot12.3, 10, Rot12Ret];{-----------------------------------------------------------------------------------------------------------------------------------------------------------------	This code reads the next word in the current list and passes control to label Switch, where a dispatch on the entry type is	executed.  The fact that this code is "at[0F, 10, EntryType]" means that a bandlist entry with type field equal to 0F is specifically	ignored, with no leftover being generated.}GetNextWord:	rReadP � MAR � [rhReadP, rReadP + 1], pCall2, CANCELBR[$]	,c1, at[Nop, 10, EntryType];GetNextWordc2:	Noop, PgCrBRANCH[GetNextWordc3, $]	,c2, at[reRead.3, 10];	rTemp � uVirtPage, CALL[reRead]	,c3;GetNextWordc3:	rTemp � MD, GOTO[Switch]	,c3;{-----------------------------------------------------------------------------------------------------------------------------------------------------------------	Rectangle entry found.  Cancel the dispatch set up for command entries, save the first word of the rectangle descriptor, and	process the rectangle.}Rectangle:	rYloc � rTemp, CANCELBR[$]		,c1, at[Rectangle, 10, EntryType];	uLO0 � rTemp				,c2;	Noop						,c3;	rReadP � MAR � [rhReadP, rReadP + 1], pCall2, 	,c1;	Noop, PgCrBRANCH[NoCross2, $]	,c2, at[reRead.B, 10];	rTemp � uVirtPage, CALL[reRead]	,c3;NoCross2:	rTemp � MD	,c3;	rReadP � MAR � [rhReadP, rReadP + 1], pCall2	,c1, at[reRead.B, 10, ReadRets];	uLO1 � rTemp, rYheight � rTemp, PgCrBRANCH[NoCross3, $]	,c2, at[reRead.4, 10];	rTemp � uVirtPage, CALL[reRead]	,c3;NoCross3:	rTemp � MD	,c3;{	Break the rectangle entry down into its individual parts.}	Q � u1FFF				,c1, at[reRead.4, 10, ReadRets];	rYloc � rYloc and Q				,c2;	Noop						,c3;		pCall2						,c1;{	Save the current real bandlist/leftover list pointer.  Also save the bandlist/leftover list virtual page number.  This is not necessary	for rectangles, since they involve no calls to Read or reRead, but it's done here so that uVirtPage can be restored, after processing	a character, with one piece of code.}	Q � rTemp and 0F {xloc}, CALL[SaveReadPtr]	,c2, at[SaveReadPtr.0, 10];	rTemp � rTemp and ~0F	,c2, at[SaveReadPtr.0, 10, SaveReadPtrRets];	rXwidth � rTemp LRot12	,c3;	rTemp � Bandwidth - Q{lines available in band}	,c1;	Ybus � rTemp - rXwidth, NegBr	,c2;	UWidth � rYheight{For BITBLT}, BRANCH[$, Neg0]	,c3;	rNlines � rXwidth, GOTO[skip]	,c1;Neg0:	rNlines � rTemp, GOTO[skip]	,c1;skip:	rXwidth � rXwidth - rNlines	,c2;	rTemp � rXwidth LRot4	,c3;	uLO2 � rTemp, rTemp � Q {xloc}	,c1;	rTemp � rTemp LRot8	,c2;	rTemp � rTemp or 000F {gray brick, 16 lines high}	,c3;	UGray � rTemp{For BITBLT}	,c1;RectRuletteCommon:	UHeight � rNlines{For BITBLT}	,c2;	rTemp � rYloc and 000F	,c3;	USrcBit � rTemp{For BITBLT}	,c1;	rTemp � uCurrentFlags	,c2;	UFlags � rTemp{For BITBLT}	,c3;	rTemp � uInkHigh	,c1;	UrhVS � rTemp{For BITBLT}	,c2;	rTemp � uCurrentInkwell	,c3;	rTemp � rTemp + Q	,c1;	USrcVALo � rTemp{For BITBLT}	,c2;{-----------------------------------------------------------------------------------------------------------------------------------------------------------------	This is where the processing for characters merges with the processing of rectangles.}{	Compute the destination address; the rectangle's word offset into the band buffer is xloc*256 + yloc/16.  Its bit offset into this	word is yloc MOD 16.  If the origin of the rectangle, rulette, or character is beyond the end of the scan line, skip it (i.e. clip it).	[Rectangles, rulettes, or characters starting within the scan line but extending past the end are not clipped in the Daybreak implementation.]}RectCharCommon:	rDest � Q{xloc}	,c3;	rDest � rDest LRot8{xloc * 256 words per scanline}	,c1;	rTemp � uBandBufLow	,c2;	rDest � rDest + rTemp{not allowed to cross banks}	,c3;	TOS � rYloc and ~0F	,c1;	UDstBit � rYloc xor TOS{For BITBLT}, L2 � Rot12.6	,c2;	rTemp � TOS, L2Disp, CALL[TempRot12]	,c3;	{rTemp � rTemp LRot12 	,c1;}	rDest � rDest + rTemp, PgCarryBr	,c2, at[Rot12.6, 10, Rot12Ret];	UDstVALo � rDest{For BITBLT}, BRANCH[$, BeyondScanLineEnd]	,c3;	rTemp � uBandBufHigh	,c1;	UrhVD � rTemp{For BITBLT}	,c2;	L2 � Rot12.8	,c3;	rTemp � 1, L2Disp, CALL[TempRot12]	,c1;	{rTemp � rTemp LRot12{256*16 bits per scanline} 	,c2;}	UDstBpl � rTemp{For BITBLT}, ListFlagDisp	,c3, at[Rot12.8, 10, Rot12Ret];	rhType � Type.LSEP{For BITBLT}, BRANCH[inLO, inBL]	,c1;inLO:	rTemp � LOlist, GOTO[saveList]	,c2;inBL:	rTemp � BL, GOTO[saveList]	,c2;saveList:	uSaveList � rTemp, GOTO[BandBLTNormEntry] {Call BITBLT}	,c3;BitBltReturn:	Xbus � uSaveList, XDisp	,c3, at[3, 8, LSEPReturn];	Xbus � dtRet.L4{retnum}, pCall3, XDisp, DISP4[dT]	,c1;	rTemp � uSaveVirtPage {restore uVirtPage}	,c3, at[dtRet.L4, 10, dTRets];	uVirtPage � rTemp, pCall1	,c1;{	Rectangle or character done.  Decide whether to write a leftover.}	[] � uLO2, ZeroBr		,c2, at[writeLO.1, 10];	rJunk � ThreeWordLO, BRANCH[writeLO, noLO]	,c3;BeyondScanLineEnd:	rTemp � uSaveVirtPage {restore uVirtPage}	,c1;	uVirtPage � rTemp,				,c2;	GOTO[noLO]					,c3;noLO:	Noop	,c1, at[writeLO.1, 10, writeLORets];RestoreReadPtr:	rhReadP � uSaveReadPHigh	,c2;	rReadP � uSaveReadPLow, GOTO[GetNextWord]	,c3;{-----------------------------------------------------------------------------------------------------------------------------------------------------------------	Processing for a character.  Control reaches here from the code beginning at Switch upon finding a bandlist (or leftover list) entry	with the sign bit off.}Char:	rCC � rTemp, CancelDisp[$],	c3;		uLO0 � rTemp,	c1;	Noop,	c2;	Noop,	c3;	rReadP � MAR � [rhReadP, rReadP + 1], pCall2	,c1;	rFont � rTemp LRot8, PgCrBRANCH[NoCross4, $]	,c2, at[reRead.C, 10];	rTemp � uVirtPage, CALL[reRead]	,c3;NoCross4:	rTemp � MD	,c3;	uLO1 � rTemp, rYloc � rTemp, ListFlagDisp	,c1, at[reRead.C, 10, ReadRets];	uLO2 � 0, BRANCH[CharLO, CharBL]	,c2;CharLO:	Noop	,c3;	rReadP � MAR � [rhReadP, rReadP + 1], pCall2	,c1;	Q � 0 {xloc}, PgCrBRANCH[NoCross5, $]	,c2, at[reRead.6, 10];	rTemp � uVirtPage, CALL[reRead]	,c3;NoCross5:	rTemp � MD	,c3;	uLO2 � rTemp, rXDisp � rTemp	,c1, at[reRead.6, 10, ReadRets];	Noop, GOTO[CharCom]	,c2;CharBL:	rTemp � rTemp LRot4	,c3;	Q � rTemp and 0F {xloc}, L2 � Rot12.7	,c1;	rTemp � rTemp and ~000F, L2Disp, CALL[TempRot12]	,c2;	{rTemp � rTemp LRot12	,c3;}	uLO1 � rTemp, rYloc � rTemp	,c1, at[Rot12.7, 10, Rot12Ret];	rXDisp � 0, GOTO[CharCom]	,c2;CharCom:	rCC � rCC and 00FF, pCall2	,c3;	rFont � LShift1 rFont, SE � 0{2*Font}, CALL[SaveReadPtr]	,c1, at[SaveReadPtr.1, 10];	rhReadP � uFPTHigh	,c1, at[SaveReadPtr.1, 10, SaveReadPtrRets];	rReadP � uFPTLow	,c2;	Noop	,c3;	rReadP � MAR � [rhReadP, rFont + 0]	,c1;	USrcBit � 0{For BITBLT}{may be changed if this is a leftover char}	,c2;	rReadV � MD {Font Vector Table ptr low word}	,c3;	MAR � [rhReadP, rFont + 1], pCall2	,c1;{	Here it's assumed that Font Vector Tables (FVT's) are page-aligned, so cc can be added into the table without worrying about	carries or page-crosses.}	rReadV � rReadV + rCC, CancelPgCross[$, 0]	,c2, at[Read.2, 10];	rhReadV � MD{FVT ptr high word}, CALL[Read] {get displacement from FVT}	,c3;	rReadV � uBitmapMemLow	,c1, at[Read.2, 10, ReadRets];	rTemp � rTemp + rTemp, CarryBr {2 * displacement}	,c2;	rCC � uBitmapMemHigh, BRANCH[$, CarryFromDisp]	,c3;	Noop, GOTO[LowAdd]	,c1;CarryFromDisp:	rCC � rCC + 1, GOTO[LowAdd]	,c1;LowAdd:	rReadV � rReadV + rTemp, CarryBr	,c2;	uRasterLow � rReadV, BRANCH[$, CarryFromAdd]	,c3;	{Noop, }pCall2, GOTO[SaveRh]	,c1;CarryFromAdd:	rCC � rCC + 1, pCall2, GOTO[SaveRh]	,c1;SaveRh:	rhReadV � rCC LRot0	,c2, at[Read.7, 10];	uRasterHigh � rCC, CALL[Read] {get bbdx}	,c3;{	Since the displacement into the rasters is even, there cannot be a page-cross between bbdx and bbdy.}	rReadP � MAR � [rhReadP, rReadP + 1]	,c1, at[Read.7, 10, ReadRets];	rTemp � rTemp - rXDisp{# of lines remaining}, CancelPgCross[$, 0]	,c2;	rJunk � MD{bbdy}	,c3;	rLoop � Bandwidth - Q{# of lines that fit in band}	,c1;	[] � rLoop - rTemp, NegBr	,c2;	UWidth � rJunk{For BITBLT}{bbdy}, BRANCH[fits, tooBig]	,c3;fits:	UHeight � rTemp{For BITBLT}	,c1;	uLO2 � 0{no leftover to be generated}, GOTO[cont]	,c2;tooBig:	UHeight � rLoop{For BITBLT}	,c1;	rTemp � uLO2 {old xdisp}	,c2;	rTemp � rTemp + rLoop {new xdisp}	,c3;	uLO2 � rTemp		,c1;	Noop, GOTO[cont]	,c2;cont:	rTemp � 64	,c3;	rTemp � rTemp LRot8 {forward, disjoint, disjointItems, not gray, null, or}	,c1;	UFlags � rTemp{For BITBLT}	,c2;	rTemp � UWidth{bbdy}		,c3;{	For .ac fonts, the rasters are padded to full-word boundaries. 	SourceBitsPerLine gets UWidth extended to word length.}	rTemp � rTemp + 000F			,c1;	rTemp � rTemp and ~000F			,c2;	USrcBpl � rTemp{For BITBLT}   		,c3;multTest:	[] � rXDisp, ZeroBr			,c1;	BRANCH[DispNonZ, DispZ]			,c2;DispZ:	rTemp � 2{bbdx & bbdy}, GOTO[AddDisp]	,c3;{	This is a leftover character, not a new one; this code computes the address of the resumption point in the rasters.	The multiplication assumes that the multiplier and multiplicand are both 12-bit numbers.  The product is accumulated in the	doubleword pair rXDisp,,Q; because there are only 12 shifts done, the result is a factor of 16 too large.  Note that Q must be inverted	at the end (after which the low 4 bits of Q are 'F'), since all shifts into Q are complemented.  This code was stolen from the	emulator's multiply byte-code.}DispNonZ:	rJunk � Q {save xloc}	,c3;	Q � rXDisp	,c1;	rXDisp � 20 {preset to two words (bbdx and bbdy)}	,c2;	rLoop � 12'd {twelve-bit multiply}	,c3;mLoop:	[] � Q and 1, NZeroBr	,c1;	rLoop � rLoop - 1, ZeroBr, BRANCH[shiftOnly, shiftAndAdd]	,c2;shiftOnly:	rXDisp � DARShift1 (rXDisp + 0), BRANCH[mLoop, mDone]	,c3;shiftAndAdd:	rXDisp � DARShift1 (rXDisp + rTemp), BRANCH[mLoop, mDone]	,c3;mDone:	rTemp � ~Q {low nybble now 0F}, {0 Disp} CALL[TempRot12]	,c1;{	rTemp � rTemp LRot12 {high nybble now 0F}	,c2;}	USrcBit � rTemp{For BITBLT} {BitBlt only looks at low four bits}	,c3, at[Rot12.0, 10, Rot12Ret];	rXDisp � rXDisp LRot8, L2 � Rot12.4	,c1;	rLoop � rXDisp and ~00FF {middle byte of word part}, L2Disp, CALL[TempRot12]	,c2;	{rTemp � rTemp LRot12 {get word part of BitAddress}	,c3;}	rTemp � rTemp and 00FF {low byte of word part}	,c1, at[Rot12.4, 10, Rot12Ret];	rTemp � rTemp or rLoop {low word of word part}	,c2;	rXDisp � rXDisp and 00FF {high byte of word part}	,c3;	Q � rJunk {restore xloc}, GOTO[GetRasterAddr]	,c1;AddDisp:	Noop	,c1;GetRasterAddr:	rReadV � uRasterLow	,c2;	rLoop � uRasterHigh	,c3;	rReadV � rReadV + rTemp, CarryBr	,c1;	rLoop � rLoop + rXDisp, BRANCH[NoCarry0, Carry0]	,c2;NoCarry0:	Noop, GOTO[common0]	,c3;Carry0:	rLoop � rLoop + 1, GOTO[common0]	,c3;common0:	USrcVALo � rReadV{For BITBLT}	,c1;	UrhVS � rLoop{For BITBLT}, GOTO[RectCharCommon]	,c2;{-----------------------------------------------------------------------------------------------------------------------------------------------------------------	Processing for a trapezoid.  Control reaches here from the code	beginning at Switch upon finding a bandlist (or leftover list)	trapezoid entry.  If this code is assembled for a Daybreak with only	one bank of control store (thereAreTwoBanks=0), then trapezoid entries	are treated as NOPs, that is, they are simply skipped over.  In the two	bank case, they are fully implemented.}Trapezoid:{IfEqual[thereAreTwoBanks,1,SkipTo[TwoBankCase],];}IfEqual[TheNumberOfBanks,3,SkipTo[TwoBankCase],];{OneBankCase (no trapezoids)}	rReadP � MAR � [rhReadP, rReadP + trapzItemLength], pCall2, CANCELBR[$]						,c1, at[Trapezoid, 10, EntryType];	Q � rReadP, PgCrBRANCH[$, TPgCross]		,c2, at[reRead.9, 10];	rTemp � MD, GOTO[Switch]				,c3;TPgCross:	rTemp � uVirtPage, CALL[reRead]				,c3;	rReadP � MAR � [rhReadP, Q + 0], pCall2, GOTO[GetNextWordc2]	,c1, at[reRead.9, 10, ReadRets];{OneBankCaseEnd}SkipTo[TwoBankCaseEnd];TwoBankCase! {(trapezoids)}{	Note that the x and y axes of the printed page are rotated 90 degrees	from the axes used in display terminology.  Hence the x axis for	TrapezoidBLT corresponds to the y axis for BandBLT, and vice versa.}	Q � rTemp and 0F {xloc}, CANCELBR[$]	,c1, at[Trapezoid, 10, EntryType];	rTemp � rTemp and ~0F			,c2;	uLO0 � rTemp				,c3;	rReadP � MAR � [rhReadP, rReadP + 1], pCall2, 	,c1;	Rbb0 � r0100 LRot4, PgCrBRANCH[NoCross6, $]	,c2, at[reRead.9, 10];	rTemp � uVirtPage, CALL[reRead]		,c3;NoCross6:	rTemp � MD				,c3;	rXwidth � rTemp				,c1, at[reRead.9, 10, ReadRets];	rTemp � Bandwidth - Q{lines available in band}	,c2;	Ybus � rTemp - rXwidth, NegBr		,c3;	UdstBpl � Rbb0,{For TzBLT} BRANCH[$, OverflowsBand]	,c1;	Rbb0 � rXwidth, GOTO[CalcLeftover]	,c2;OverflowsBand:	Rbb0 � rTemp				,c2;CalcLeftover:	rXwidth � rXwidth - Rbb0		,c3;	uLO1 � rXwidth				,c1;	UTzbHeight � Rbb0{For TzBLT}, Rbb0 � Q{xloc},c2;	rTemp � Rbb0 LRot8 {xloc = TzBLT yOffset}	,c3;	{rTemp � [yOffset, widthMinusOne (always 0), heightMinusOne (always 15)]}	rTemp � rTemp or 000F			,c1;	rScratch � uCurrentFlags		,c2;	rScratch � rScratch LRot4		,c3;	{add in srcFunc & dstFunc}	rScratch � rScratch and ~00FF		,c1;	rTemp � rTemp or rScratch		,c2;	UTzbFlags � rTemp{For TzBLT}		,c3;	{Src = current inkwell pointer + xloc [not allowed to cross 64K banks]}	rTemp � uCurrentInkwell			,c1;	rTemp � rTemp + Q{xloc}			,c2;	UStzVALo � rTemp{For TzBLT}		,c3;	rDest � Q{xloc}				,c1;	{Dest = bandBuf+(xloc*wordsPerScanline) [not allowed to cross 64K banks]}	rDest � rDest LRot8			,c2;	rTemp � uBandBufLow			,c3;	rDest � rDest + rTemp			,c1;	UDtzVALo � rDest{For TzBLT}		,c2;	{Fold inkwell (source) rh and band buffer (destination) rh into one U	register for TrapezoidBLT}	rTemp � uInkHigh			,c3;	rTemp � rTemp and 00FF			,c1;	rTemp � rTemp LRot8			,c2;	rTemp � rTemp or uBandBufHigh		,c3;	UrhTzbVSD � rTemp{For TzBLT}		,c1;	Rbb0 � xMinValFrac			,c2;	Noop					,c3;InterpolatorLoop:	rReadP � MAR � [rhReadP, rReadP + 1], pCall2	,c1;	rScratch � xMaxdValInt, PgCrBRANCH[NoCross7, $]	,c2, at[reRead.A, 10];	{rScratch has to be reset above every time through the loop even though        its value doesn't change, because microcode encoding constraints require	it to be written (and smashed) below on the loop exit test}	rTemp � uVirtPage, CALL[reRead]		,c3;NoCross7:	rTemp � MD				,c3;	Ybus � Rbb0, rScratch � rScratch - Rbb0, AltUaddr, ZeroBr	,c1, at[reRead.A, 10, ReadRets];	{rScratch is written above only to meet microcode encoding constraints}	uyBlk0 � rTemp, BRANCH[$, InterpExit], ListFlagDisp	,c2;	Rbb0 � Rbb0 + 1, CANCELBR[InterpolatorLoop, 01]	,c3;InterpExit:	rhType � Type.LSEP{For TzBLT}, BRANCH[inLeftover, inBandList]	,c3;inLeftover:	rTemp � LOlist, GOTO[saveListID], pCall2,c1;inBandList:	rTemp � BL, pCall2			,c1;saveListID:	uSaveList � rTemp, CALL[SaveReadPtr]	,c2, at[SaveReadPtr.4, 10];	{five cycles in SaveReadPtr, c3-c1}	{dest.bit = 0 (always points to the first bit of the scan line)}	UtzDstBit � 0{For TzBLT} ,c2, at[SaveReadPtr.4, 10, SaveReadPtrRets];	rTemp � UXMinValInt			,c3;	{src.bit = yMin.val.int MOD bitsPerWord (inkwells are word-aligned with	the band buffer, by definition)}	rTemp � rTemp and 000F{for TzBLT}	,c1;	Bank � bank2{Bank � bank1}		,c2;	{CALL TrapezoidBLT!}	UtzSrcBit � rTemp, GOTOBANK2[BandBLTNormalEntry]{GOTOBANK1[BandBLTNormalEntry]}	,c3;TrapzReturn:	Xbus � uSaveList, XDisp			,c3, at[{Type.LSEP,8,LSEPReturn}addrTrapzReturn];	Xbus � dtRet.L5{retnum}, pCall3, XDisp, DISP4[dT]	,c1;	{RET[dTRets]				,c2, at[0 or 1,10,dT];}	rTemp � uSaveVirtPage {restore uVirtPage}	,c3, at[dtRet.L5, 10, dTRets];	uVirtPage � rTemp			,c1;	[] � uLO1, ZeroBr			,c2;	rJunk � UXMinValFrac, BRANCH[$, noTrLO]	,c3;	uLO2 � rJunk				,c1;	rJunk � ThreeWordLO{ + 7 (encoded in L1)}, pCall1	,c2;	CALL[writeLO]				,c3, at[writeLO.4, 10];	GOTO[RestoreReadPtr]			,c1, at[writeLO.4, 10, writeLORets];noTrLO:	GOTO[RestoreReadPtr]			,c1;TwoBankCaseEnd!