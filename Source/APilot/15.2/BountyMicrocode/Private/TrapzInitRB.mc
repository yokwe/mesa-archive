{File name TrapzInit.mcCreated:   13-Jun-86 13:20:36Author:  MRRLast edited by JPM: 21-Sep-91  9:52:46: change register namesLast edited by JPM: 22-Aug-91 13:18:23: add FIFO simulation codeLast edited by JPM: 5-Dec-90 14:42:45: use bankBandBLT for LSEP returnLast edited by JPM: 8-Oct-87 12:26:43: use standard return pathsLast edited by JPM: 5-Jan-87 8:52:50: removed code (at TzBExit) that did MesaIntRq for page crossLast edited by MRR: 13-Oct-86 9:39:37: inserted optimizations resulting from code inspection of 9/23/86	Description: Mesa TrapezoidBlt op-code. This file originated from BitBlt (bbInit.mc). The primary differences between BitBlt and TrapezoidBlt are as follows: only gray objects are transfered, sloped sides are assumed and BltLineGray is used for ITEM transfers. The steps taken to transfer an item are as follows:	For an OBJECT do :		o fetch the arguments,		o check if done ( height equals zero ),	   For each ITEM do Height times:		o bring into VM all ITEM dst pages plus one ITEM source gray brick,		o map and align BltLineGray arguments,		o call BltLineGray to display ITEM,		o increment ITEM loop variables,		o test for a zero height (done),		o check for any interrupts.	this file was printed with the following XDE Executive command:			>print gacha8/f /-a TrapzInit.mc}	{ 	Copyright (C) 1986, 1987, 1990 by Xerox Corporation.  All rights reserved. }@TRAPZBLT:	{Save R and RH registers}	ULsave � L, pCall2, CALL[SavetzbRegs],		,c1, at[04,10,ESCAn];	{SaveRegs subroutine here {2 2/3 Clicks}	,c2-c3;}	rhType � Type.normal, push			,c1, at[0,10,SavetzbRegsRet]; {set Pge Flt type}	Xbus � ErrnIBnStkp, XDisp			,c2;	L1 � 0, DISP4[tzbHowBigStack,08]		,c3; {determine if the call is original, a  							Return from an interrupt, or page fault}	{move TrapezBltArg to stack and rh}tzbNormEntry: {non-interrupts come here get real address of TrapzBltArg and insure that it is 0 mod 32}	VD � UTrapezBltArgLo				,c1, at[hbs.3,10,tzbHowBigStack];	Noop						,c2;	rhVD � UTrapezBltArgHi				,c3;	Tzbtmp � 0, L2 � sd.spec			,c1; {set bit offset to zero}	L3 � L3.TrapzArg, VD � VD and ~1F		,c2;	dstWidth � 0, CALL[ComMap]			,c3;	{ComMap subroutine here {# Clicks}		,c1-c1;}	BRANCH[$,SrcFault]				,c2, at[L3.TrapzArg,10,ComMapRet];	GOTO[getargs]					,c3;{************************************************************************************************	fetch arguments from memory	 ************************************************************************************************}getargs:MAR � [BARealAHi,BARealALo+ 01]				,c1;	Noop, CANCELBR[$,2]					,c2;	VD � rhVD � MD{ DHi }					,c3;	MAR � [BARealAHi,BARealALo+ 10], L0 � 0			,c1;	CANCELBR[$,2], L0Disp					,c2;MD2Rbb0:Rbb0 � MD{UTzbHeight}, DISP4[MD2Rbb0Ret]		,c3;	MAR � [BARealAHi,BARealALo+ 07], L0 � 1			,c1, at[0,10,MD2Rbb0Ret];	UTzbHeight � Rbb0, CANCELBR[MD2Rbb0,0], L0Disp		,c2;{MD2Rbb0:Rbb0 � MD{UTzbFlags}, DISP4[MD2Rbb0Ret]		,c3;}	MAR � [BARealAHi,BARealALo+ 0F], L0 � 2			,c1, at[1,10,MD2Rbb0Ret];	UTzbFlags � Rbb0, CANCELBR[MD2Rbb0,0], L0Disp		,c2;{MD2Rbb0:Rbb0 � MD{UXMaxdValInt}, DISP4[MD2Rbb0Ret]		,c3;}	MAR � [BARealAHi,BARealALo+ 0E], L0 � 3			,c1, at[2,10,MD2Rbb0Ret];	UXMaxdValInt � Rbb0, CANCELBR[MD2Rbb0,0], L0Disp	,c2;{MD2Rbb0:Rbb0 � MD{UXMaxdValFrac}, DISP4[MD2Rbb0Ret]		,c3;}	MAR � [BARealAHi,BARealALo+ 0D], L0 � 4			,c1, at[3,10,MD2Rbb0Ret];	UXMaxdValFrac � Rbb0, CANCELBR[MD2Rbb0,0], L0Disp	,c2;{MD2Rbb0:Rbb0 � MD{UXMaxValInt}, DISP4[MD2Rbb0Ret]		,c3;}	MAR � [BARealAHi,BARealALo+ 0C], L0 � 5			,c1, at[4,10,MD2Rbb0Ret];	UXMaxValInt � Rbb0, CANCELBR[MD2Rbb0,0], L0Disp		,c2;{MD2Rbb0:Rbb0 � MD{UXMaxValFrac}, DISP4[MD2Rbb0Ret]		,c3;}	MAR � [BARealAHi,BARealALo+ 0B], L0 � 6			,c1, at[5,10,MD2Rbb0Ret];	UXMaxValFrac � Rbb0, CANCELBR[MD2Rbb0,0], L0Disp	,c2;{MD2Rbb0:Rbb0 � MD{UXMindValInt}, DISP4[MD2Rbb0Ret]		,c3;}	MAR � [BARealAHi,BARealALo+ 0A], L0 � 7			,c1, at[6,10,MD2Rbb0Ret];	UXMindValInt � Rbb0, CANCELBR[MD2Rbb0,0], L0Disp	,c2;{MD2Rbb0:Rbb0 � MD{UXMindValFrac}, DISP4[MD2Rbb0Ret]		,c3;}	MAR � [BARealAHi,BARealALo+ 09], L0 � 8			,c1, at[7,10,MD2Rbb0Ret];	UXMindValFrac � Rbb0, CANCELBR[MD2Rbb0,0], L0Disp	,c2;{MD2Rbb0:Rbb0 � MD{UXMinValInt}, DISP4[MD2Rbb0Ret]		,c3;}	MAR � [BARealAHi,BARealALo+ 08], L0 � 9			,c1, at[8,10,MD2Rbb0Ret];	UXMinValInt � Rbb0, CANCELBR[MD2Rbb0,0], L0Disp 	,c2;{MD2Rbb0:Rbb0 � MD{UXMinValFrac}, DISP4[MD2Rbb0Ret]		,c3;}	MAR � [BARealAHi,BARealALo+ 4], L0 � 0A			,c1, at[9,10,MD2Rbb0Ret];	UXMinValFrac � Rbb0, CANCELBR[MD2Rbb0,0], L0Disp	,c2;{MD2Rbb0:Rbb0 � MD{UStzVALo}, DISP4[MD2Rbb0Ret]			,c3;}	MAR � [BARealAHi,BARealALo+ 0], L0 � 0B			,c1, at[0A,10,MD2Rbb0Ret];	UStzVALo � Rbb0, CANCELBR[MD2Rbb0,0], L0Disp		,c2;{MD2Rbb0:Rbb0 � MD{UDtzVALo}, DISP4[MD2Rbb0Ret]			,c3;}	MAR � [BARealAHi,BARealALo+ 3], L0 � 0C			,c1, at[0B,10,MD2Rbb0Ret];	UDtzVALo � Rbb0, CANCELBR[MD2Rbb0,0], L0Disp		,c2;{MD2Rbb0:Rbb0 � MD{UdstBpl}, DISP4[MD2Rbb0Ret]			,c3;}	MAR � [BARealAHi,BARealALo+ 6], L0 � 0D			,c1, at[0C,10,MD2Rbb0Ret];	UdstBpl � Rbb0, CANCELBR[MD2Rbb0,0], L0Disp		,c2;{MD2Rbb0:Rbb0 � MD{UtzSrcBit}, DISP4[MD2Rbb0Ret]		,c3;}	MAR � [BARealAHi,BARealALo+ 2], L0 � 0E			,c1, at[0D,10,MD2Rbb0Ret];	UtzSrcBit � Rbb0, CANCELBR[MD2Rbb0,0], L0Disp		,c2;{MD2Rbb0:Rbb0 � MD{UtzDstBit}, DISP4[MD2Rbb0Ret]		,c3;}	MAR � [BARealAHi,BARealALo+ 05]				,c1, at[0E,10,MD2Rbb0Ret];	UtzDstBit � Rbb0, CANCELBR[$,0]				,c2;	VS � rhVS � MD{SHi}					,c3;{************************************************************************************************	initialize ITEM loop constants and prepare to transfer an object an ITEM (,or line) at at time.  An interrupt entry goes thru this code.	 ************************************************************************************************}	Rbb0 � VS LRot8						,c1;	UrhTzbVSD � VD or Rbb0					,c2; {combine high src and dst addrs}	[] � UdstBpl or 0, ZeroBr				,c3; {test for a zero dst Bpl}	Q � UXMindValInt, BRANCH[shiftToWrkRegs, $]		,c1;	Noop							,c2;isZero:	TzbUpdVar � Q and ~0F					,c3; {remove fractional part}	UdstBpl � TzbUpdVar					,c1; {save extracted dstBpl}	UtzDstBit � 0						,c2; {since offset in interp.}	Tzbtmp � Q - TzbUpdVar  				,c3;	UXMindValInt � Tzbtmp					,c1; {ext DstBpl�XMin interpolator}	Q � UXMaxdValInt 					,c2;	Tzbtmp � Q - TzbUpdVar  				,c3;	UXMaxdValInt � Tzbtmp, GOTO[shiftToWrkRegs]		,c1; {ext DstBpl�XMax interpolator}BandBLTNormalEntry:	GOTO[shiftToWrkRegs]					,c1, at[addrBandBLTNormalEntry];BandBLTIntEntry:	Q � UXMindValInt, GOTO[getSBit]				,c1, at[addrBandBLTIntEntry];	Q � UXMindValInt, GOTO[getSBit]				,c1, at[hbs.F,10,tzbHowBigStack];getSBit:Tzbtmp � UTzbFlags					,c2;	Tzbtmp � Tzbtmp LRot12					,c3; {rotate to width-1 parameter}	Tzbtmp � Tzbtmp and 0F					,c1; {isolate source bit value}	UtzSrcBit � Tzbtmp, GOTO[shiftToWrkRegsCont]		,c2;shiftToWrkRegs:	[] � UTzbHeight or 0, ZeroBr				,c2; {test for zero height}shiftToWrkRegsCont:	BRANCH[$, noHeight]					,c3;	TzbUpdVar � UrhTzbVSD					,c1;	Q � TzbUpdVar and 0FF					,c2;	UWrkrhVD � Q						,c3; {move Dst VAHi Wrk�stk}	TzbUpdVar � TzbUpdVar LRot8				,c1;	Q � TzbUpdVar and 0FF					,c2;	UWrkrhVS � Q						,c3; {move Src VAHi Wrk�stk}	TzbAnother � UTzbFlags					,c1; {prepare to isolate yOffset}	Tzbtmp � TzbAnother LRot8				,c2; {rotate to yOffset}	Tzbtmp � Tzbtmp and 0F					,c3; {mask off Unnecessary bits}	UyOffset � Tzbtmp					,c1; {save yOffset value}	Tzbtmp � TzbAnother LRot12				,c2; {prepare to erase yOffset}	TzbAnother � Tzbtmp and ~0FF				,c3; {mask out yOffset/SBit from Flags}	Tzbtmp � TzbAnother LRot4				,c1; {rotate back into place}	UTzbFlags � Tzbtmp					,c2; {store Flags w/o yOffset}	Tzbtmp � UtzDstBit					,c3; {get rid of these Noops later}{************************************************************************************************	this routine maps all the destination pages spanning the ITEM's width, checking also for Write Protect as well as its presence in memory (ComMapSub). The ITEM width is calculated and is used to count the number of pages to be tested. Proceed in preparing BltLineGray arguments. Also the current source gray brick word needs to be mapped into VM.	 ************************************************************************************************}ItemLoop:VD � UXMinValInt					,c1;	dstWidth � UWrkrhVD, L4 � L4.TrapzLoop			,c2;	srcWrdOffset � UDtzVALo, CALL[BBASubEntry]      	,c3;		{ BumpBitAddress subroutine here {8 cycles}		,c1-c2;}	UtmpHi � dstWidth				,c3, at[L4.TrapzLoop,10,BumpBitAddressRet];	UtmpLo � srcWrdOffset					,c1;	Utmpdstbit � Tzbtmp					,c2;	Q � UXMinValInt						,c3; {save hi addr during dst check}	dstWidth � UXMaxValInt, L1 � 1				,c1; {set Dst Bit offset}	dstWidth � dstWidth - Q, L3 � L3.TrapzDst, CarryBr	,c2; {select Dst mapping}	UdstWidth � dstWidth, BRANCH[doNegcase, mapit]		,c3; {save ITEM width for BLG call}doNegcase:	dstWidth � ~dstWidth					,c1; {get ABS value, 2's Comp}	dstWidth � dstWidth + 1					,c2;	UdstWidth � dstWidth					,c3;mapit:  Tzbtmp � Utmpdstbit, L2 � sd.src			,c1; {map all dest pages}	VD � UtmpLo						,c2;	rhVD � UtmpHi, CALL[ComMap]				,c3;	{ ComMap subroutine called here {10-11 1/3 clicks}	,c1-c1;}	{  Map the source gray brick }	Q � 01F, L1 � 0, BRANCH[$, DstFault]			,c2, at[L3.TrapzDst,10,ComMapRet];	[] � BARealAHi and Q, ZeroBr				,c3;	uRingBufSaveDst � BARealALo, L7 � 0{/1}, BRANCH[$,dstIsDisplayBank],c1;	dstWidth � UWrkrhVS, GOTO[continueMappingIt]		,c2;dstIsDisplayBank:	dstWidth � UWrkrhVS					,c2;continueMappingIt:	DBit � UtzSrcBit       					,c3;	rhVD � dstWidth LRot0					,c1; {select source mapping}	VD � UStzVALo, L3 � L3.TrapzSrc       			,c2;	dstWidth � 10, CALL[ComMap]				,c3;	{ ComMap subroutine called here {10-11 1/3 clicks}	,c1-c1;}	Tzbtmp � UtzSrcBit, BRANCH[$, SrcFault1]		,c2, at[L3.TrapzSrc,10,ComMapRet];	Q � Utmpdstbit						,c3;	{ once the raw gray word has been retrieved from memory, rotate the gray word around, using the source bit offset, Min Val interploator and Destination bit offset, to be aligned for the BltLineGray gray word parameter. }getGrayWord:	{request raw gray word}	MAR � [BARealAHi, BARealALo+0]				,c1;	Noop			 				,c2; 	Grayword � MD,						,c3; {fetch raw gray word}	Ybus � Tzbtmp - Q, YDisp				,c1; {MOD 16}	TzbAnother � LRot1 Grayword, DISP4[grayRot]		,c2; {prerotate gray word}	GOTO[prepCall]						,c3, at[0,10,grayRot];	Grayword � TzbAnother, GOTO[prepCall]			,c3, at[1,10,grayRot];	Grayword � LRot1 TzbAnother, GOTO[prepCall]		,c3, at[2,10,grayRot];	Grayword � RRot1 Grayword, GOTO[fourShift]		,c3, at[3,10,grayRot];	GOTO[fourShift]						,c3, at[4,10,grayRot];	Grayword � LRot1 Grayword, GOTO[fourShift]		,c3, at[5,10,grayRot];	Grayword � LRot1 TzbAnother, GOTO[fourShift]		,c3, at[6,10,grayRot];	Grayword � RRot1 Grayword, GOTO[eightShift]		,c3, at[7,10,grayRot];	GOTO[eightShift]       					,c3, at[8,10,grayRot];	Grayword � LRot1 Grayword, GOTO[eightShift]		,c3, at[9,10,grayRot];	Grayword � LRot1 TzbAnother, GOTO[eightShift]		,c3, at[0A,10,grayRot];	Grayword � RRot1 Grayword, GOTO[twelveShift]		,c3, at[0B,10,grayRot];	GOTO[twelveShift]					,c3, at[0C,10,grayRot];	Grayword � LRot1 Grayword, GOTO[twelveShift]		,c3, at[0D,10,grayRot];	Grayword � LRot1 TzbAnother, GOTO[twelveShift]		,c3, at[0E,10,grayRot];	Grayword � RRot1 Grayword, GOTO[prepCall]		,c3, at[0F,10,grayRot];fourShift:	Grayword � Grayword LRot4, GOTO[prepC1]			,c1;eightShift:	Grayword � Grayword LRot8, GOTO[prepC1]			,c1;twelveShift:	Grayword � Grayword LRot12, GOTO[prepC1]		,c1;{ at this point the gray word and the ITEM width, in bits, are ready for a BltLineGray call.}prepCall:Noop							,c1;prepC1: rVirtualL � UtmpLo					,c2; {push Dst VA lo onto stack}	rhVirtualH � UtmpHi					,c3; {push Dst VA hi onto stack}	DstBit � Utmpdstbit					,c1; {save new bit offset}	temp � UTzbFlags					,c2; {push Dst bit offset onto stack}	TzbUpdVar � temp LRot4					,c3; {do src and dst funcs}	temp � temp LRot1					,c1;	temp � temp and 01					,c2;	temp � temp or TzbUpdVar				,c3;	L3 � L3.TrapzBLG					,c1;	GCount � UdstWidth, CALL[BLGSubEntry]			,c2; {push gray word and call}		{ BltLineGray subroutine here {20 2/3 clicks}		,c3-c2;}{************************************************************************************************	Upon return from the BltLineGray call, increment loop variables, adjust interpolators and check for interrupts. Test for zero height (done).	 ************************************************************************************************}	{attend to loop variables}test4done:	Tzbtmp � UTzbHeight, L7Disp				,c3, at[L3.TrapzBLG,10,BLTLineGrayRet];test4addToRB:	Tzbtmp � Tzbtmp - 1, ZeroBr, BRANCH[$,addToRB]		,c1; {dec height, check for ints}	UTzbHeight � Tzbtmp, L2 � 0, BRANCH[$, tzbNormDone]	,c2;	CALL[BumpVars]						,c3;	{ BumpVars routine here					,c1-c3; }{ check for interrupts }	Tzbtmp � UtzDstBit       				,c1, at[ 0, 10, BumpVarsRet];	MesaIntBr 						,c2; {if not ints queued, }	BRANCH[ItemLoop, tzbDoInt]				,c3; {loop back for next ITEM}			{ Microcode and Mesa exits }noHeight:[] � rhType, XDisp, L0 � restore.term, GOTO[tzbExit]	,c1;tzbNormDone:Noop						,c3;tzbNormExit:	[] � rhType, XDisp, L0 � restore.term			,c1;tzbExit:stackP � 0, L2 � 1, DISP4[LSEPReturn]			,c2;	{will go to RestoreRandRHRegs if not LSEP, uses target values of 2 and 4}	{RestoreRandRHRegs subroutine {2 1/3 clicks}		,c3-c3;}	CALL[BumpVars]						,c3, at[Type.LSEP,10,LSEPReturn];	{ BumpVars routine here					,c1-c3; }	Bank � bankBandBLT, GOTOABS[TrapzReturn]		,c1, at[1,10,BumpVarsRet];TzBExit:PC � PC + 1, Bank � r0100 {= bank0 in low 4 bits}, GOTOABS[Bank1NxtInstc2],c1, at[restore.term,10,tzbRestoreCallers];			{ handle Daybreak Interrupts }tzbDoInt:stackP � 0E						,c1;	rhWho � 0, CALL[SaveStack]				,c2;	{ SaveStack subroutine here {# clicks}			,c3-c2;}	L0 � restore.int					,c3, at[0E,10,SaveStackRet];tzbRestore:	TOS � UTzbHeight, CALL[MovrhVToStkandRestore]		,c1;	{RestoreRandRHRegs subroutine {2 1/3 clicks}		,c2-c2;}	PC � PC + 1, GOTOABS[Bank1Interrupt]		,c3, at[restore.int,10,tzbRestoreCallers];	{ handle source (argument pointer, or gray brick) and destination PAGE FAULTS }DstFault:UVSsave � Q						,c3;	uFaultParm0 � VD					,c1;	Q � rhVD, GOTO[pgfCom]					,c2;SrcFault:UVSsave � Q, GOTO[SrcFaultPlus1]			,c3;SrcFault1:UVSsave � Q						,c3;SrcFaultPlus1:	uFaultParm0 � VD, L2Disp				,c1;	Q � rhVD, DISP4[pgfCom] 				,c2;pgfCom: uFaultParm1 � Q, GOTO[tzbprepstk]			,c3, at[sd.src,10,pgfCom];       	stackP � 2, GOTO[tzbDoFault]				,c3, at[sd.spec,10,pgfCom];tzbprepstk:	stackP � 0E						,c1;	rhWho � 1, CALL[SaveStack]				,c2;	{ SaveStack subroutine here {10-11 clicks}		,c3-c2;}	Q � uFaultParm1,GOTO[tzbDoFault]			,c3, at[0F,10,SaveStackRet];tzbDoFault:	L0 � restore.pf, uFaultParm1 � Q			,c1;	Noop							,c2;	GOTO[tzbRestore]					,c3;	{RestoreRandRHRegs subroutine {2 1/3 clicks}		,c2-c2;}	T � UVSsave					,c3, at[restore.pf,10,tzbRestoreCallers];	PC � PC + 1						,c1;	GOTOABS[Bank1Fault]					,c2;{Ring buffer routine}addToRB:	Tb � uRingBufPos, CANCELBR[$]				,c2;	rhTb � 0						,c3;	DstA � uRingBufSaveDst					,c1;	Lcount � UdstWidth					,c2;	Q � Utmpdstbit						,c3;	Lcount � Lcount + Q					,c1;	Lcount � Lcount + 0F					,c2;	Lcount � Lcount and ~0F					,c3;	MAR � [rhTb, Tb + 0]					,c1;	MDR � DstA						,c2;	Lcount � Lcount LRot12					,c3;	MAR � [rhTb, Tb + 1]					,c1;	MDR � Lcount, LOOPHOLE[wok], CANCELBR[$,0]		,c2;	Q � uRingBufEnd						,c3;	[] � Tb xor Q, ZeroBr					,c1;	Tc � 0, BRANCH[$,RBWraparound]				,c2;	Q � Tb + 2, GOTO[RBWaitNotFull]				,c3;RBWraparound:	Q � rRingBuf + 6					,c3;RBWaitNotFull:	MAR � [rhRingBuf, rRingBuf + 0]				,c1;	[] � Tc, NZeroBr					,c2;	Tc � MD xor Q, BRANCH[RBWaitNotFull,$]			,c3;	MAR � [rhRingBuf, rRingBuf + 1]				,c1;	MDR � Q, LOOPHOLE[wok], CANCELBR[$,0]			,c2;	uRingBufPos � Q						,c3;	MAR � [rhRingBuf, rRingBuf + 0]				,c1;	uRingBufEntry � Q					,c2;	Tc � Tb xor MD						,c3;	[] � Tc, NZeroBr					,c1;	T � uMesaProc, BRANCH[$,doneWithRB]			,c2;	rhT � uIORgnHigh					,c3;	MAR � [rhRingBuf, rRingBuf + 3]				,c1;	TT � T + downNotifyBits, CANCELBR[$,0]			,c2;	rhRx � Rx � MD						,c3;	MAR � [rhT, T + notifiersLockMask]			,c1;	T � Rx and ~0FF, CANCELBR[$,0]				,c2;	TOS � MD						,c3;	Rx � RShift1 rhRx, XLDisp				,c1;	TT � TT + Rx, BRANCH[MaskInLowByte,$,2]			,c2;	GOTO[SoftwareLock]					,c3;MaskInLowByte:	T � T LRot8						,c3;SoftwareLock:	MAR � [rhIORgn, rIORgn + iopRequestsLock]		,c1;	CANCELBR[$,0]						,c2;	Rx � MD							,c3;	Rx � TOS and Rx						,c1;	[] � Rx, ZeroBr {zero iff lock available}		,c2;	BRANCH[SoftwareLock,$]					,c3;	MAR � [rhIORgn, rIORgn + mesaHasLock]			,c1;	MDR � TOS, CANCELBR[$,0]				,c2;	rhTT � uIORgnHigh					,c3;	MAR � [rhTT, TT + 0]					,c1;	Noop							,c2;	T � T or MD						,c3;	MAR � [rhTT, TT + 0], SetMPIntIOP			,c1;	MDR � T							,c2;	Noop							,c3;	MAR � [rhIORgn, rIORgn + mesaHasLock]			,c1;	MDR � 0, ClrMPIntIOP, CANCELBR[$,0]			,c2;doneWithRB:	Tzbtmp � UTzbHeight, GOTO[test4addToRB]			,c3;{************************************************************************************************	END ************************************************************************************************} 