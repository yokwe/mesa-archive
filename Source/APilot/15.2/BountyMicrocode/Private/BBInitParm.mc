{File name BBInit.mcDescription: Mesa BitBlt op-codeJPM, 12-Nov-91 12:17:17, make sure bit offsets are normalized to [0..15]JPM, 16-Oct-91 14:42:36, add parameterized entriesJPM, 23-Sep-91 23:32:37, back out a "fix" that did nothingJPM, 21-Sep-91 22:00:58, use subroutinesJPM, 17-Sep-91 13:33:07, fix bug in rectangle codeJPM, 10-Sep-91 16:24:34, add rectangle codeJPM, 28-Aug-91 11:47:42, change alignment of FIFOSimRetJPM, 12-Jul-91 14:05:16, add FIFO simulation codeJPM, 5-Dec-90 15:39:30, Hard-wired BandBLT entry address and put in bank switch for return.JPM, 5-Jan-87 8:51:34, Removed code (at BBExit) that did MesaIntRq for page cross.CRF, 23-Jul-86 13:01:22, Changed HowBigStack dispatch mask to allow for BandBLT trapezoid return from interrupt case.JPM, 9-Oct-84 10:04:04, Simplified Interrupt handlingDEG, 1-Sep-84 19:19:04  Add copyright noticeHGM, 27-Sep-83 21:55:44, Patch for Dicentra InterruptsJGS  November 2, 1981  2:28 PM New Instruction SetLast edited by JXF August 20, 1981  2:20 PM: Fix for new assembler. Last edited by JXF: March 31, 1981  8:39 AM: Change SrcMapRet from Mod 8 to Mod 10.Last edited by DXC: March 6, 1981  1:48 PM: Fixed PageFault/64K cross interaction problem.Last edited by DXC: March 3, 1981  4:08 PM: Moved UWidth into stack, no memory reads after int and pf, stack now has 12'd things.Last edited by PXO: February 27, 1981  2:51 PMLast edited by DXC: February 26, 1981  2:35 PM: Add changes for new stack size to save 10 instructions.Author: DXC     Created: January, 1980}{ 	Copyright (C) 1982, 1983, 1984, 1991 by Xerox Corporation.  All rights reserved.}@BITBLT:	{Save R and RH registers}	ULsave � L, pCall2, CALL[SavebbRegs],	,c1, at[0B,10,ESC2n];	{SaveRegs subroutine here {2 2/3 Clicks}	,c2-c3;}	 rhType � Type.normal, push	,c1, at[0,10,SavebbRegsRet];	Xbus � ErrnIBnStkp, XDisp	,c2, at[Savebb.BANDBLT,10,SavebbRegsRet];	Noop, DISP4[HowBigStack,08]	,c3;	{move BitBltArg to stack and rh}bbNormEntry: {non-interrupts come here}	{get real address of BitBltArg}	{and insure that it is 0 mod 16}	VS � UBitBltArg,	,c1, at[hbs.2,10,HowBigStack];	{rhVS = rhMDS, so no need to load it}	VS � VS and ~0F, L2 � sd.spec	,c2;	rhRet � argMap, CALL[SrcMapSpec]	,c3;	{SrcMapSpec subroutine here {2 Clicks}	,c1-c3;}bbGetArg:	{move BitBltArg to U registers}{rtn here}	MAR � [rhSrcA,SrcA + 8], L0 � 0	,c1, at[argMap,10,SrcMapRet];	CANCELBR[$,0], L0Disp	,c2;MDtoRbb0:	Rbb0 � MD{UWidth}, DISP4[MDtoRbb0Ret]	,c3;	MAR � [rhSrcA,SrcA + 0A], L0 � 1	,c1, at[0,10,MDtoRbb0Ret];	UWidth � Rbb0, CANCELBR[MDtoRbb0,0], L0Disp	,c2;{MDtoRbb0:	Rbb0 � MD{UFlags}, DISP4[MDtoRbb0Ret]	,c3;}	MAR � [rhSrcA,SrcA + 3], L0 � 2	,c1, at[1,10,MDtoRbb0Ret];	UFlags � Rbb0, CANCELBR[MDtoRbb0,0], L0Disp	,c2;{MDtoRbb0:	Rbb0 � MD{UDstBpl}, DISP4[MDtoRbb0Ret]	,c3;}	MAR � [rhSrcA,SrcA + 7], L0 � 3	,c1, at[2,10,MDtoRbb0Ret];	UDstBpl � Rbb0, CANCELBR[MDtoRbb0,0], L0Disp	,c2;{MDtoRbb0:	Rbb0 � MD{SrcBpl}, DISP4[MDtoRbb0Ret]	,c3;}	MAR � [rhSrcA,SrcA + 9], L0 � 4	,c1, at[3,10,MDtoRbb0Ret];	USrcBpl � Rbb0, CANCELBR[MDtoRbb0,0], L0Disp	,c2;{MDtoRbb0:	Rbb0 � MD{Height}, DISP4[MDtoRbb0Ret]	,c3;}	MAR � [rhSrcA,SrcA + 0], L0 � 5	,c1, at[4,10,MDtoRbb0Ret];	UHeight � Rbb0, CANCELBR[MDtoRbb0,0], L0Disp	,c2;{MDtoRbb0:	Rbb0 � MD{DLo}, DISP4[MDtoRbb0Ret]	,c3;}	MAR � [rhSrcA,SrcA + 2], L0 � 6	,c1, at[5,10,MDtoRbb0Ret];	UDstVALo � Rbb0, CANCELBR[MDtoRbb0,0], L0Disp	,c2;{MDtoRbb0:	Rbb0 � MD{DBit}, DISP4[MDtoRbb0Ret]	,c3;}	MAR � [rhSrcA,SrcA + 4], L0 � 7	,c1, at[6,10,MDtoRbb0Ret];	UDstBit � Rbb0, CANCELBR[MDtoRbb0,0], L0Disp	,c2;{MDtoRbb0:	Rbb0 � MD{SLo}, DISP4[MDtoRbb0Ret]	,c3;}	MAR � [rhSrcA,SrcA + 6], L0 � 8	,c1, at[7,10,MDtoRbb0Ret];	USrcVALo � Rbb0, CANCELBR[MDtoRbb0,0], L0Disp	,c2;{MDtoRbb0:	Rbb0 � MD{SBit}, DISP4[MDtoRbb0Ret]	,c3;}	MAR � [rhSrcA,SrcA + 5]	,c1, at[8,10,MDtoRbb0Ret];	USrcBit � Rbb0, CANCELBR[$,0]	,c2;	VS � rhVS � MD{SHi}	,c3;	MAR � [rhSrcA,SrcA + 1]	,c1;	UrhVS � VS, CANCELBR[$,0]	,c2;	VD � rhVD � MD{DHi}	,c3;	[] � UFlags, NegBr	,c1;	UrhVD � VD, BRANCH[FsetUp,$]	,c2;	{if direction backward, mod SrcVA and DstVA}	{Note:  gray is always forward}	{Backwards SetUp}	TempBpl � UWidth	,c3;	TempBpl � TempBpl - 1, rhWho � sdWidth, CALL[DstVAMod]	,c1;	{DstVAMod subroutine here {4 clicks}	,c2-c1;}	TempBpl � UWidth	,c2, at[sdWidth,4,DstVAModRet];	TempBpl � TempBpl - 1, CALL[SrcVAMod]	,c3;	{SrcVAMod subroutine here {4 clicks}	,c1-c3;}	{interrupt entry goes thru this code}	{restore rh from u regs}BandBLTNormEntry:	rhVS � UrhVS, GOTO[rhfromu]	,c1, at[{hbs.C,10,HowBigStack}addrBandBLTNormEntry];	rhVS � UrhVS, GOTO[rhfromu]	,c1, at[hbs.D,10,HowBigStack];rhfromu:	rhVD � UrhVD	,c2;FsetUp:	Noop	,c3;TextBltToBitBltEntry:	Rbb3{W} � UWidth, L7 � RBEntryUnknown	,c1, at[sdWidth,4,SrcVAModRet];	Rbb0{W-1} � Rbb3{W} - 1, NegBr {test if width = 0}	,c2;	Rbb2 � 0F, BRANCH[$,Widtheq0]	,c3;	Rbb2 � Rbb2 LRot12	,c1;	[] � Rbb2 and Rbb3, ZeroBr	,c2;	Rbb1 � 8, BRANCH[wnotsmall,wsmall]	,c3;wnotsmall:	Q � 2	,c1;	Q � Q or rhType	,c2;	rhType � Q LRot0	,c3;wsmall:	Rbb4 � UFlags, NegBr	,c1;	Rbb3 � Rbb4 LRot4, BRANCH[DirFor,DirBack]	,c2;DirFor:	Rbb1 � 0	,c3;	Rbb2{W-1} � Rbb0{W-1}, GOTO[uwwpos]	,c1;DirBack:	Rbb0 � 0 - Rbb0, NegBr	,c3;	Rbb2{0-(W-1)} � 0 - Rbb0{W-1}, BRANCH[uwwpos,uwwneg]	,c1;uwwpos:	Rbb2 � Rbb2 and ~0F, GOTO[conL13]	,c2;uwwneg:	Rbb2 � Rbb2 or 0F, GOTO[conL13]	,c2;conL13:	Rbb2 � Rbb2 LRot12{this only used for PgCarry and sign check}	,c3;	UWidthM1 � Rbb0	,c1;	UWidthW � Rbb2	,c2;	[] � UHeight, ZeroBr {test if height = 0}	,c3;	{L3 � 0,,gr,,0,,sF}	{gr and srcFunc}	Rbb0 � LRot1 Rbb3, BRANCH[$,Heighteq0]	,c1;	Rbb0 � Rbb0 and 3	,c2;	Rbb0 � Rbb0 + 6	,c3;	[] � Rbb0 and 5, YDisp	,c1;	Xbus � dtRet.L3, L3 � 0, XDisp, DISP4[dT]	,c2;	{dT subroutine here {1 cycle}	,c3;}	{dstFunc and dir}	Rbb0 � Rbb4 LRot8	,c1, at[dtRet.L3,10,dTRets];	Rbb0 � Rbb0 and 6	,c2;	[] � Rbb0 or Rbb1, YDisp	,c3;	Xbus � dtRet.L1, L1 � 0, XDisp, DISP4[dT]	,c1;	{dT subroutine here {1 cycle}	,c2;}	Rbb0 � UDstBpl	,c3, at[dtRet.L1,10,dTRets];	[] � Rbb0 and 0F, ZeroBr	,c1;	Rbb1 � dbneq0, grDisp, BRANCH[dstwn0,$]	,c2;	Rbb0 � USrcBpl, grDISP[srcgrchk]	,c3;	Xbus � 1, XDisp, GOTO[srcchk]	,c1, at[gr.gray,grM,srcgrchk];	[] � Rbb0 and 0F, ZeroBr, GOTO[srcchk]	,c1, at[gr.notgray,grM,srcgrchk];srcchk:	Rbb1 � sbneq0, BRANCH[sbnot0,sbis0]	,c2;sbis0:	UrefillType � dbsb0, GOTO[SetUpAllC1]	,c3;sbnot0:	UrefillType � Rbb1{sbneq0}, GOTO[SetUpAllC1]	,c3;dstwn0:	UrefillType � Rbb1{dbneq0}, CANCELBR[SetUpAllC1,0F]	,c3;{	ITEM REFILL	}	{updateHeight, test if thru}ItemRefill3:	Rbb0 � UHeight, L2 � sd.src	,c3;	Rbb0 � Rbb0 - 1, ZeroBr, L6 � RBBitBltDone	,c1;	UHeight � Rbb0, grDisp, BRANCH[$,bbNormExit]	,c2;	rhWho � sdBpl, grDISP[srcgrayornot]	,c3;{notGray}	TempBpl � USrcBpl, CALL[SrcVAMod]	,c1, at[gr.notgray,grM,srcgrayornot];	{SrcVAMod subroutine {4 clicks}	,c2-c1;}	{will return to dstUphere}	{update Src address}{gray}	Rbb0{max} � UGray	,c1, at[gr.gray,grM,srcgrayornot];	Rbb1{cur} � Rbb0 LRot8	,c2;	Rbb0{max} � Rbb0 and 0F, ZeroBr	,c3;	Rbb1{cur} � Rbb1 and 0F, BRANCH[$,dstUphere]	,c1;	Rbb1{cur+1} � Rbb1{cur} + 1	,c2;	[] � Rbb0{max} - Rbb1{cur+1}, NegBr	,c3;	Rbb1 � Rbb1 LRot8, BRANCH[$,GrayWrap]	,c1;	{not gray wrap}	UGray � Rbb1 xor Rbb0	,c2;	Rbb2{usva} � USrcVALo	,c3;	Rbb2{usva+1} � Rbb2{usva} + 1, PgCarryBr	,c1;	Noop, BRANCH[$,GrayNewPage]	,c2;	USrcVALo � Rbb2{usva+1}	,c3;	GOTO[dstUphere]	,c1;GrayNewPage:	Noop ,c3;	TempBpl � 10, CALL[SrcVAMod]	,c1;GrayWrap:	UGray � Rbb0	,c2;	Rbb1{maxX10} � Rbb0{max} LRot4	,c3;	Rbb2{usva} � USrcVALo	,c1;	Rbb2{usva-max} � Rbb2{usva} - Rbb0{max}, PgCarryBr	,c2;	Noop, BRANCH[GrayWrapNewPage,$]	,c3;	USrcVALo � Rbb2{usva-max}, GOTO[dstUphere]	,c1;GrayWrapNewPage:	TempBpl � 0 - Rbb1{maxX10}, CALL[SrcVAMod]	,c1;	{update Dst address}dstUphere:	TempBpl � UDstBpl, CALL[DstVAMod]	,c2, at[sdBpl,4,SrcVAModRet];	{DstVAMod subroutine {4 clicks}	,c3-c2;}	{will return to IntTest}IntTest:	Q � UWidthM1, MesaIntBr, L6 � RBBitBltInt	,c3, at[sdBpl,4,DstVAModRet];		BRANCH[bbNoInt, bbDoInt]	,c1;	{no mesa interrupt}bbNoInt:	Xbus � UrefillType, XDisp,	,c2;SetUpTest:	[] � USrcBit + Q, NibCarryBr, LOOPHOLE[niblTiming], DISP2[SetUpAllC1]	,c3;SetUpAllC1:	{Lcount � number of dest words to be written minus 1 }	Rbb1 � UDstBit, dirDisp, CANCELBR[$]	,c1, at[dbneq0,4,SetUpAllC1];	Lcount � Rbb1 and 0F, dirDISP[lcx]	,c2;	Lcount � 10 - Lcount	,c3, at[dir.backwards,dirM,lcx];	Rbb0 � ~UWidthM1, GOTO[lccont]	,c1;	Rbb0 � UWidthM1	,c3, at[dir.forward,dirM,lcx];	Noop, GOTO[lccont]	,c1;lccont:	Lcount � Lcount + Rbb0	,c2;	Lcount � Lcount and ~0F	,c3;	{Umask1 � Rmask[0 - DstBit]}	[] � 0F - Rbb1{db}, YDisp	,c1;	Xbus � maskRet.f1, XDisp, DISP4[MaskTbl]	,c2;	{MaskTbl subroutine here {1 cycle}	,c3;}	Lcount � Lcount LRot12, dirDisp	,c1, at[maskRet.f1,10,MaskRet];	ULcntsav � Lcount, dirDISP[m2set]	,c2;	{FORWARD MASKS HERE}	Umask1 � Rbb2	,c3, at[dir.forward,dirM,m2set];	Rbb0{-w+1} � 0 - Rbb0{w-1}	,c1;	[] � Rbb0{-w+1} - Rbb1{db} - 1, YDisp	,c2;	Xbus � maskRet.f2, XDisp, DISP4[MaskTbl]	,c3;	{MaskTbl subroutine here {1 cycle}	,c1;}	Rbb2 � RShift1 ~Rbb2, SE � 1, GOTO[stum2]	,c2, at[maskRet.f2,10,MaskRet];	{BACKWARDS MASKS HERE}	Rbb2 � RShift1 ~Rbb2, SE � 1	,c3, at[dir.backwards,dirM,m2set];	Noop	,c1;	Umask1 � Rbb2	,c2;	{Umask2 � Rmask[width - DstBit - 1]}	[] � Rbb0{w-2} - Rbb1{db}, YDisp	,c3;	Xbus � maskRet.b2, XDisp, DISP4[MaskTbl]	,c1;	{MaskTbl subroutine here	,c2;}stum2:	Umask2 � Rbb2	,c3, at[maskRet.b2,10,MaskRet];	{L0 � skew + 2}	Rbb0{sb} � USrcBit, dirDisp, CANCELBR[$]	,c1, at[sbneq0,4,SetUpAllC1];	Rbb1{db} � UDstBit, dirDISP[WhichMasks]	,c2;	{Q � Rmask[SrcBit - DstBit]}	[] � Rbb0{sb} - Rbb1{db} - 1, YDisp	,c3, at[dir.forward,dirM,WhichMasks];	Xbus � maskRet.fQ, XDisp, DISP4[MaskTbl]	,c1;	{MaskTbl subroutine here {1 cycle}	,c2;}	GOTO[setL0] {leave pre-Qmask in Rbb2}	,c3, at[maskRet.fQ,10,MaskRet];	{Q � Lmask[DstBit - SrcBit]}	[] � Rbb0{sb} - Rbb1{db}, YDisp	,c3, at[dir.backwards,dirM,WhichMasks];	Xbus � maskRet.bQ, XDisp, DISP4[MaskTbl]	,c1;	{MaskTbl subroutine here {1 cycle}	,c2;}	Rbb2 � RShift1 ~Rbb2, SE � 1, GOTO[setL0] {leave pre-Qmask in Rbb2}	,c3, at[maskRet.bQ,10,MaskRet];setL0:	Rbb0{skew} � Rbb0{sb} - Rbb1{db}	,c1;	[]{skew+2} � Rbb0{skew} + 2, YDisp	,c2;	[] � dtRet.L0, L0 � 0, XDisp, DISP4[dT]	,c3;	{dT subroutine here {1 cycle}	,c1;}	scDisp	,c2, at[dtRet.L0,10,dTRets];	Q � UWidthM1, sc3DISP[FixQ]	,c3;	Rbb2 � LRot1 Rbb2, GOTO[SavQval]	,c1, at[0D,10,FixQ];	Rbb2 � RRot1 Rbb2, GOTO[SavQval]	,c1, at[0F,10,FixQ];SavQval:	UmaskL � Rbb2, L2 � sd.src	,c2;	[] � USrcBit + Q, NibCarryBr, {L2 � sd.src},  LOOPHOLE[niblTiming]	,c3;TouchSourcePages:	Q � UWidthW, NegBr, BRANCH[oldWords,newWords]	,c1, at[dbsb0,4,SetUpAllC1];oldWords:	BRANCH[oldposchks,oldnegchks]	,c2;newWords:	Q � Q + 1, PgCarryBr, BRANCH[newposchks1,newnegchks1]	,c2;oldposchks:	[] � rhType, XDisp, GOTO[oldposs1]	,c3;oldnegchks:	[] � rhType, XDisp, GOTO[oldnegs1]	,c3;newposchks1:	[] � rhType, XDisp, BRANCH[oldposs1,newposs1]	,c3;newnegchks1:	[] � rhType, XDisp, BRANCH[newnegs1,oldnegs1]	,c3;oldposs1:	[] � USrcVALo + Q, PgCarryBr, DISP3[SrcsmallP,5], LOOPHOLE[byteTiming]	,c1;newposs1:	CANCELBR[$,7]	,c1;	Noop, CANCELBR[pospgs,1]	,c2, at[type.notsmall,typeM,SrcsmallP];	rhRet � MapOne, BRANCH[posnopgs,pospgs]	,c2, at[type.small,typeM,SrcsmallP];newnegs1:	[] � USrcVALo + Q , PgCarryBr, DISP3[SrcsmallN,5], LOOPHOLE[byteTiming]	,c1;oldnegs1:	Xbus � 1, XDisp, DISP3[SrcsmallN,5]	,c1;	rhRet � MapOne, BRANCH[negpgs,negnopgs]	,c2, at[type.small,typeM,SrcsmallN];	Noop, CANCELBR[pospgs,1]	,c2, at[type.notsmall,typeM,SrcsmallN];pospgs:	Q � USrcVALo, grDisp, GOTO[smapmore]	,c3;negpgs:	Q � USrcVALo, grDisp, GOTO[smapmore]	,c3;smapmore:	TempB � USrcBit, grDISP[schkgray]	,c1;	rhRet � srcTP	,c2, at[gr.notgray,grM,schkgray];callva:	TempBpl � UWidthM1, CALL[VAMod]	,c3;	{VAMod subroutine here {2 or 3 clicks}	,c1-c3;}	VS � rhVS + TempBpl, GOTO[fixrhVS], LOOPHOLE[byteTiming]	,c1, at[Or[srcTP,1],8,VAModRet];	TempB{old} � USrcVALo, GOTO[comA]	,c1, at[srcTP,8,VAModRet];comA:	Q{new hi} � Q and ~0FF, dirDisp	,c2;	TempBpl{old hi} � TempB and ~0FF, dirDISP[comA.1]	,c3;	TempBpl{num hi} � Q{new hi} - TempBpl{old hi}, GOTO[comX]	,c1, at[dir.forward,dirM,comA.1];	TempBpl{num hi} � TempBpl{old hi} - Q{new hi}, GOTO[comX]	,c1, at[dir.backwards,dirM,comA.1];comX:	TempB{old low} � TempB{old} and 0FF	,c2;	TempB � TempB{old low} or Q{new hi}, sdDisp	,c3;	TempBpl{num low} � TempBpl LRot8, sdDISP[comB]	,c1;	VS � TempB	,c2, at[sd.src,sdM,comB];csrc:	rhRet � sdMap, CALL[SrcMapSpec]	,c3;sSnonewrhF:	VS � USrcVALoSav, CALL[SrcMapSpec]	,c3;sSnonewrhB:	VS � USrcVALoSav, CALL[SrcMapSpec]	,c3;{	SrcMapSpec subroutine here  2  clicks	,c1-c3;}	TempBpl � TempBpl - 1, NegBr	,c1, at[sdMap,10,SrcMapRet];	VS � 0FF + 1, dirDisp, BRANCH[srcmore,srcthru]	,c2;srcmore:	TempB � USrcVALoSav, dirDISP[y.f]	,c3;	TempB � TempB - VS, CarryBr	,c1, at[dir.forward,dirM,y.f];	USrcVALoSav � TempB, BRANCH[sSnewrhF,sSnonewrhF]	,c2;sSnewrhF:	VS � rhVS - 1, LOOPHOLE[byteTiming]	,c3;y.c:	rhVS � VS LRot0	,c1;	CALL[SrcMap]	,c2;	TempB � TempB + VS, CarryBr	,c1, at[dir.backwards,dirM,y.f];	USrcVALoSav � TempB, BRANCH[sSnonewrhB,sSnewrhB]	,c2;sSnewrhB:	VS � rhVS + 1, GOTO[y.c], LOOPHOLE[byteTiming]	,c3;srcthru:	CANCELBR[$,Sub[dirM,2]]	,c3;	Mask2 � Umask2 {Mask2 = VS}, GOTO[sss]	,c1;	rhRet � MapOne, GOTO[posnopgs]	,c2, at[gr.gray,grM,schkgray];posnopgs:	VS � USrcVALo, CALL[SrcMapSpec]	,c3;negnopgs:	VS � USrcVALo, CALL[SrcMapSpec]	,c3;{	SrcMapSpec subroutine here  2 clicks	,c1-c3;}srcFin:	Mask2 � Umask2 {Mask2 = VS}, GOTO[sss]	,c1, at[MapOne,10,SrcMapRet];sss:	Q � UWidthM1	,c2;	[] � UDstBit + Q, NibCarryBr, L2 � sd.dst, LOOPHOLE[niblTiming]	,c3;TouchDestPages:	Q � UWidthW, NegBr, BRANCH[oldWordd,newWordd]	,c1;oldWordd:	BRANCH[oldposchkd,oldnegchkd]	,c2;newWordd:	Q � Q + 1, PgCarryBr, BRANCH[newposchkd1,newnegchkd1]	,c2;oldposchkd:	[] � rhType, XDisp, GOTO[oldposd1]	,c3;oldnegchkd:	[] � rhType, XDisp, GOTO[oldnegd1]	,c3;newposchkd1:	[] � rhType, XDisp, BRANCH[oldposd1,newposd1]	,c3;newnegchkd1:	[] � rhType, XDisp, BRANCH[newnegd1,oldnegd1]	,c3;oldposd1:	[] � UDstVALo + Q, PgCarryBr, DISP3[DstsmallP,5], LOOPHOLE[byteTiming]	,c1;newposd1:	CANCELBR[$,7]	,c1;	Noop, CANCELBR[pospgd,1]	,c2, at[type.notsmall,typeM,DstsmallP];	rhRet � MapOne, BRANCH[posnopgd,pospgd]	,c2, at[type.small,typeM,DstsmallP];newnegd1:	[] � UDstVALo + Q, PgCarryBr, DISP3[DstsmallN,5], LOOPHOLE[byteTiming]	,c1;oldnegd1:	Xbus � 1, XDisp, DISP3[DstsmallN,5]	,c1;	rhRet � MapOne, BRANCH[negpgd,negnopgd]	,c2, at[type.small,typeM,DstsmallN];	Noop, CANCELBR[pospgd,1]	,c2, at[type.notsmall,typeM,DstsmallN];pospgd:	Q � UDstVALo, GOTO[dmapmore]	,c3;negpgd:	Q � UDstVALo, GOTO[dmapmore]	,c3;dmapmore:	TempB � UDstBit	,c1;	rhRet � dstTP, GOTO[callva]	,c2;{callva:	TempBpl � UWidthM1, CALL[VAMod]	,c3;}	{VAMod subroutine here {2 or 3 clicks}	,c1-c3;}	VD � rhVD + TempBpl, GOTO[fixrhVD], LOOPHOLE[byteTiming]	,c1, at[Or[dstTP,1],8,VAModRet];	TempB{old} � UDstVALo, GOTO[comA]	,c1, at[dstTP,8,VAModRet];{comA:	Q{new hi} � Q and ~0FF, dirDisp	,c2;}{	TempBpl{old hi} � TempB and ~0FF, sdDisp, dirDISP[comA.1]	,c3;}{	TempBpl{num hi} � Q{new hi} - TempBpl{old hi}, GOTO[comX]	,c1, at[dir.forward,dirM,comA.1];}{	TempBpl{num hi} � TempBpl{old hi} - Q{new hi}, GOTO[comX]	,c1, at[dir.backwards,dirM,comA.1];}{comX:	TempB{old low} � TempB{old} and 0FF	,c2;}{	TempB � TempB{old low} or Q{new hi}, sdDisp	,c3;}{	TempBpl{num low} � TempBpl LRot8, sdDISP[comB]	,c1;}	VD � TempB{first touch address}	,c2, at[sd.dst,sdM,comB];cdst:	rhRet � sdMap, CALL[DstMapSpec]	,c3;dSnonewrhF:	VD � UDstVALoSav, CALL[DstMapSpec]	,c3;dSnonewrhB:	VD � UDstVALoSav, CALL[DstMapSpec]	,c3;{	DstMapSpec subroutine here  2 clicks	,c1-c3;}	TempBpl � TempBpl - 1, NegBr	,c1, at[sdMap,4,DstMapRet];	VD � 0FF + 1, dirDisp, BRANCH[dstmore,dstthru]	,c2;dstmore:	TempB � UDstVALoSav, dirDISP[y.fx]	,c3;	TempB � TempB - VD, CarryBr	,c1, at[dir.forward,dirM,y.fx];	UDstVALoSav � TempB, BRANCH[dSnewrhF,dSnonewrhF]	,c2;dSnewrhF:	VD � rhVD - 1, LOOPHOLE[byteTiming]	,c3;y.cx:	rhVD � VD LRot0	,c1;	CALL[DstMap]	,c2;	TempB � TempB + VD, CarryBr	,c1, at[dir.backwards,dirM,y.fx];	UDstVALoSav � TempB, BRANCH[dSnonewrhB,dSnewrhB]	,c2;dSnewrhB:	VD � rhVD + 1, GOTO[y.cx], LOOPHOLE[byteTiming]	,c3;dstthru:	CANCELBR[$,Sub[dirM,2]]	,c3;	Lcount � ULcntsav, L7Disp, GOTO[detLoop]	,c1;posnopgd:	VD � UDstVALo, CALL[DstMapSpec]	,c3;negnopgd:	VD � UDstVALo, CALL[DstMapSpec]	,c3;{	DstMapSpec subroutine here  2 clicks	,c1-c3;}dstFin:	Lcount � ULcntsav, L7Disp, GOTO[detLoop]	,c1, at[MapOne,4,DstMapRet];	{determine loop and entry point}detLoop:	Mask1 � Umask1, grDisp, BRANCH[detLoopCont,$,RBEntU]	,c2;	{check for display write}	Q � DisplayBankMask, CANCELBR[$,7]	,c3;	[] � Q and rhDstA, NZeroBr, L7 � RBEntryNone	,c1;	grDisp, BRANCH[$,detLoopCont]	,c2;	[] � Q and rhSrcA, NZeroBr, grDISP[DisplayGrayChk]	,c3;	BRANCH[DisplayBlock,DisplayRect]	,c1, at[gr.notgray,grM,DisplayGrayChk];	Temp � UGray, XDisp, CANCELBR[$]	,c1, at[gr.gray,grM,DisplayGrayChk];	[] � Temp and ~3, NZeroBr, L6 � 0C{thru 0F}, DISP4[DisplayPatSize,0C]	,c2;	BRANCH[DisplayReadPat0,DisplayCantUsePat]	,c3, at[0C,10,DisplayPatSize];	[] � Temp and r0100, ZeroBr, BRANCH[DisplayReadPat0,DisplayCantUsePat]	,c3, at[0D,10,DisplayPatSize];	CANCELBR[DisplayCantUsePat]	,c3, at[0E,10,DisplayPatSize];	Temp � LShift1 (Temp + Temp), BRANCH[$,DisplayCantUsePat4]	,c3, at[0F,10,DisplayPatSize];	Xbus � Temp LRot8, XDisp	,c1;	L6 � 03{thru 0F}, DISP4[DisplayPat4,03]	,c2;	GOTO[DisplayReadPat0]	,c3, at[03,10,DisplayPat4];	GOTO[DisplayReadPat0]	,c3, at[07,10,DisplayPat4];	GOTO[DisplayReadPat0]	,c3, at[0B,10,DisplayPat4];	L6 � 0A, GOTO[DisplayReadPat0]	,c3, at[0F,10,DisplayPat4];DisplayCantUsePat:	CANCELBR[DisplayRect]	,c1;DisplayCantUsePat4:	GOTO[DisplayRect]	,c1;DisplayReadPat0:	MAR � [rhSrcA, SrcA + 0], BRANCH[$,DisplayPat2Offset0]	,c1;	L6Disp, GOTO[DisplayPat0]	,c2;DisplayPat2Offset0:	Xbus � 3, XDisp	,c2;DisplayPat0:	Q � MD, DISP4[DisplayReadPat1,0C]	,c3;	MAR � [rhSrcA, SrcA - 1], GOTO[DisplayPat1]	,c1, at[0D,10,DisplayReadPat1];	MAR � [rhSrcA, SrcA - 3], GOTO[DisplayPat1]	,c1, at[0E,10,DisplayReadPat1];	MAR � [rhSrcA, SrcA + 1], GOTO[DisplayPat1]	,c1, at[0F,10,DisplayReadPat1];DisplayPat1:	uRingBufSaveP0 � Q, L6Disp, BRANCH[$,DisplayPatCarry1,1]	,c2;	Q � MD, DISP4[DisplayReadPat2,03]	,c3;	MAR � [rhSrcA, SrcA + 2], GOTO[DisplayPat2]	,c1, at[03,10,DisplayReadPat2];	MAR � [rhSrcA, SrcA + 2], GOTO[DisplayPat2]	,c1, at[07,10,DisplayReadPat2];	MAR � [rhSrcA, SrcA - 2], GOTO[DisplayPat2]	,c1, at[0B,10,DisplayReadPat2];DisplayPat2:	uRingBufSaveP1 � Q, L6Disp, BRANCH[$,DisplayPatCarry2,1]	,c2;	Q � MD, DISP4[DisplayReadPat3,03]	,c3;	MAR � [rhSrcA, SrcA + 3], GOTO[DisplayPat3]	,c1, at[03,10,DisplayReadPat3];	MAR � [rhSrcA, SrcA - 1], GOTO[DisplayPat3]	,c1, at[07,10,DisplayReadPat3];	MAR � [rhSrcA, SrcA - 1], GOTO[DisplayPat3]	,c1, at[0B,10,DisplayReadPat3];DisplayPat3:	uRingBufSaveP2 � Q, BRANCH[$,DisplayPatCarry3,1]	,c2;	Q � MD, GOTO[DisplayPatFinish]	,c3;DisplayPatCarry1:	CANCELBR[DisplayCantUsePat4,0F]	,c3;DisplayPatCarry2:	CANCELBR[DisplayCantUsePat4,0F]	,c3;DisplayPatCarry3:	GOTO[DisplayCantUsePat4]	,c3;	uRingBufSaveP0 � Q	,c1, at[0C,10,DisplayReadPat1];	uRingBufSaveP1 � Q	,c2;	uRingBufSaveP2 � Q, GOTO[DisplayPatFinish]	,c3;	uRingBufSaveP1 � Q	,c1, at[0F,10,DisplayReadPat2];	Temp � uRingBufSaveP0	,c2;	uRingBufSaveP2 � Temp, GOTO[DisplayPatFinish]	,c3;DisplayPatFinish:	uRingBufSaveP3 � Q	,c1;	Q � ~0FE {FF01}, L7 � RBEntryPattern	,c2;	uRingBufData0 � Q	,c3;	Dst � UDstBit, GOTO[DisplayParmFinish]	,c1;DisplayBlock:	Q � ~0FD {FF02}, L7 � RBEntryBlock	,c2;	uRingBufData0 � Q	,c3;	Src � USrcBit, dirDisp	,c1;	Dst � UDstBit, dirDISP[DisplayBlockSvSD]	,c2;	Q � UWidthM1	,c3, at[dir.backwards,dirM,DisplayBlockSvSD];	Src � Src - Q	,c1;	Dst � Dst - Q	,c2;	Src � Src and 0F	,c3, at[dir.forward,dirM,DisplayBlockSvSD];	uRingBufSaveSrc � SrcA	,c1;	uRingBufSaveSBit � Src	,c2;	Noop	,c3;	Noop	,c1;DisplayParmFinish:	Dst � Dst and 0F, L5 � RBWaitPatOrBlock	,c2;	uRingBufSaveDBit � Dst, CALL[RBWaitForEmpty]	,c3;	{RBWaitForEmpty subroutine here c1 - c3, 2 clicks unless wait is required}	Q � UWidth, GOTO[DisplayGo]	,c1, at[RBWaitPatOrBlock,8,RBWaitRet];DisplayRect:	Q � ~0FF {FF00}, L7 � RBEntryRectangle	,c2;	uRingBufData0 � Q	,c3;	Q � Lcount + 1	,c1;DisplayGo:	uRingBufData1 � Q	,c2;	Q � UHeight, L5 � RBBitBltInit	,c3;	uRingBufSaveH � Q, CALL[RBAdd2Words]	,c1;	uRingBufSaveDst � DstA, grDisp	,c2, at[RBBitBltInit,8,RBAdd2Ret];detLoopCont:	Q � UmaskL, grDISP[chooseLoop]	,c3;	{if gray then Entry to L1 and L2D at L1I1lsar}	{Entry to L4}L4SetUp:	dirDisp, Dst � UDstBit{Dbit}	,c1, at[gr.notgray,grM,chooseLoop];	Src � USrcBit{Sbit}, dirDISP[CheckL4Init]	,c2;	{forward: fetch 1 if Dbit >= Sbit, else fetch 2}	[] � Dst{Dbit} - Src{Sbit}, NibCarryBr, GOTO[L4I1lsar]	,c3, at[dir.forward,dirM,CheckL4Init];	{backwards: fetch 1 if Sbit >= Dbit, else fetch 2}	[] � Src{Sbit} - Dst{Dbit}, NibCarryBr, GOTO[L4I1lsar]	,c3, at[dir.backwards,dirM,CheckL4Init];	{Exits}bbNormExit:	Lcount � uRingBufSaveH, L7Disp, CANCELBR[$,Sub[grM,1]]	,c3;	Lcount � Lcount - Rbb0, DISP3[DisplayFinish,RBEntryUnknown]	,c1;	L6Disp	,c2, at[RBEntN,8,DisplayFinish];	DISP4[RBAdvRet]	,c3;	DstA � uRingBufSaveDst, L6Disp	,c2, at[RBEntR,8,DisplayFinish];DisplayFinishEntry:	uRingBufData0 � Lcount, L5 � 0{value in L6}, DISP4[DisplayWriteEntry]	,c3;	uRingBufData1 � DstA, CALL[RBAdd2Words]	,c1, at[RBBitBltFault,10,DisplayWriteEntry];	uRingBufData1 � DstA, CALL[RBAdd2Words]	,c1, at[RBBitBltInt,10,DisplayWriteEntry];	uRingBufData1 � DstA, CALL[RBAdd2Words]	,c1, at[RBBitBltDone,10,DisplayWriteEntry];	Q � uRingBufSaveSrc, L5 � RBBitBltPat23OrSrc	,c2, at[RBEntB,8,DisplayFinish];	uRingBufData0 � Q	,c3;	Q � uRingBufSaveSBit	,c1;	uRingBufData1 � Q	,c2;	DstA � uRingBufSaveDst	,c3;	Dst � uRingBufSaveDBit, CALL[RBAdd2Words]	,c1;	{subroutine returns below}	Q � uRingBufSaveP0, L5 � RBBitBltPat01	,c2, at[RBEntP,8,DisplayFinish];	uRingBufData0 � Q	,c3;	Q � uRingBufSaveP1	,c1;	uRingBufData1 � Q	,c2;	DstA � uRingBufSaveP2	,c3;	Dst � uRingBufSaveP3, CALL[RBAdd2Words]	,c1;	uRingBufData0 � DstA, L5 � RBBitBltPat23OrSrc	,c2, at[RBBitBltPat01,8,RBAdd2Ret];	uRingBufData1 � Dst	,c3;	DstA � uRingBufSaveDst	,c1;	Dst � uRingBufSaveDBit, CALL[RBAdd2BackDoor]	,c2;	uRingBufData0 � DstA, L5 � RBBitBltDst	,c2, at[RBBitBltPat23OrSrc,8,RBAdd2Ret];	uRingBufData1 � Dst, CALL[RBAdd2Resume]	,c3;	DstA � Lcount	,c2, at[RBBitBltDst,8,RBAdd2Ret];	Lcount � UFlags	,c3;	Lcount � Lcount LRot8	,c1;	Lcount � Lcount and 0E, L6Disp, GOTO[DisplayFinishEntry]	,c2;Heighteq0:	Noop	,c2;bbExitc3:	Noop	,c3;Widtheq0:	[] � rhType, XDisp, L0 � restore.term	,c1, at[RBBitBltDone,10,RBAdvRet];	stackP � 0, DISP3[LSEPReturn,2]	,c2;	{will go to RestoreRandRHRegs if not LSEP}	{RestoreRandRHRegs subroutine {2 1/3 clicks}	,c3-c3;}BBExit:	PC � PC + 1, GOTO[IBDispOnly]	,c1, at[restore.term,10,RestoreCallers];IfEqual[bankBandBLT,bankBitBLT,SkipTo[NoBandBLTBankSwitch],];{BandBLT is in another bank, so transfer}ReturnToBandBLT:	Noop	,c3, at[3,8,LSEPReturn];	Bank � bankBandBLT	,c1;	GOTOBANK[BitBLTReturn]	,c2;NoBandBLTBankSwitch!	{Mesa Interrupt}bbDoInt:	Rbb0 � UHeight, GOTO[bbNormExit]	,c2;	TOS � UWidth, CANCELBR[$]	,c1, at[RBBitBltInt,10,RBAdvRet];	stackP � 0C, L0 � restore.int	,c2;	Xbus � rhType, XDisp	,c3;	DISP3[MoverhVToStkandRestore,3]	,c1;	{RestoreRandRHRegs subroutine {2 1/3 clicks}	,c2-c2;}	{Return to BlockInt in InteruptsDaybreak}	{PAGE FAULTS}DFault:	UVSsave � Q, L0 � 1	,c3;	uFaultParm0 � VD	,c1;	Q � rhVD	,c2;	stackP � 0C, L0Disp, GOTO[bbDoFault]	,c3;SFault:	UVSsave � Q, L0 � 1	,c3;	uFaultParm0 � VS, sdDisp	,c1;	Q � rhVS, sdDISP[pfCom]	,c2;pfCom:	stackP � 0C, GOTO[bbDoFault]	,c3, at[sd.src,sdM,pfCom];	stackP � 1, L0Disp, GOTO[bbDoFault]	,c3, at[sd.spec,sdM,pfCom];bbDoFault:	uFaultParm1 � Q, L6 � RBBitBltFault, BRANCH[$,bbDoFaultCont]	,c1;	Rbb0 � UHeight, GOTO[bbNormExit]	,c2;	TOS � UWidth	,c1, at[RBBitBltFault,10,RBAdvRet];bbDoFaultCont:	L0 � restore.pf	,c2;	Xbus � rhType, XDisp	,c3;	DISP3[MoverhVToStkandRestore,3]	,c1;	{RestoreRandRHRegs subroutine {2 1/3 clicks}	,c2-c2;}	T � UVSsave {Trap index}	,c3, at[restore.pf,10,RestoreCallers];	Rx � pFault, GOTO[SaveRegs]	,c1;		{END}