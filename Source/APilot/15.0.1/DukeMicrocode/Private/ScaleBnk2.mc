{File name:  ScaleBnk2.mcDescription: ScaleBitsToGray opcodeAuthor: JPMCreated: December 3, 1986Last Revised:SxO/TxH 13-Sep-88 11:48:09 moved to bank2; changed the file name;	JPM	 8-Oct-87	Cancel branch before GOTOABS (so address isn't constrained).JPM	19-Dec-86	Fixed bug in previous change (bad mask in a CANCELBR).JPM	18-Dec-86	Fixed one-byte cases at start and/or end of destination line; move reg defs to Daybreak.dfn, some constants to Mesa.dfn.JPM	15-Dec-86	Added comments.}{ 	Copyright (C) 1986 by Xerox Corporation.  All rights reserved.}{local constants}Set[SBTGSizeLess1, 8];Set[SBTGLastIndex, 0B];Set[SBTGScale.twoByTwo, 3];Set[SBTGScale.fourByFour, 2];Set[SBTGScale.eightByEight, 1];Set[SBTGScale.sixteenBySixteen, 0];Set[SBTGMaskedScale.fourByFour, Or[SBTGScale.fourByFour,0C]];Set[SBTGMaskedScale.eightByEight, Or[SBTGScale.eightByEight,0C]];{Link register use:	L0 - returns from LoadTable, MapSrc, MapDst, and LRotateN subroutines	L1 - used when calling ComMapSub	L2 - used for inner loop control (0 = high dst byte, 1 = low dst byte,	     2 = start with low dst byte, 4 or more = end of line)	L3 - returns from ComMap subroutine	L4 - scale factor; also used for return from BBASubEntry subroutine	L5 - used for outer loop control (3 = first source line, 0 = last source line, 1 = neither first nor last)}@SCALEBITSTOGRAY:{Check stack size for reentry}	Xbus � ErrnIBnStkp, XDisp, L0 � L0.SBTG,			c1, at[0F,10,ESCAn];	rTemp � SBTGSizeLess1, push, BRANCH[SBTGReentry,$,7],		c2;{First time in, load stack regs from argument table}	rhVirtualH � STK, pop,						c3;	Map � rVirtualL � [rhVirtualH, STK or rTemp], fXpop, fZpop, CALL[LoadTable], c1;{LoadTable subroutine starts in c2, ends in c3}	rPixelCount � uSBTGPixelCount, ZeroBr,				c1, LoadTableRet[L0.SBTG];	Xbus � uSBTGScale, XDisp, BRANCH[$,SBTGEnd],			c2;	bitWidth � LShift1 rPixelCount, SE � 0, push, DISP4[SBTGScale1,0C], c3;{Calculate source bit width based on pixel count and scale factor;  also compute number of source lines to process & set first-time flag}	Noop,								c1, at[Or[SBTGScale.twoByTwo,0C],10,SBTGScale1];	rCount � LShift1 2, SE � 1, GOTO[SBTGInit],			c2;	bitWidth � LShift1 bitWidth, SE � 0,				c1, at[Or[SBTGScale.fourByFour,0C],10,SBTGScale1];	rCount � LShift1 4, SE � 1, GOTO[SBTGInit],			c2;	bitWidth � LShift1 bitWidth + bitWidth, SE � 0,			c1, at[Or[SBTGScale.eightByEight,0C],10,SBTGScale1];	rCount � LShift1 8, SE � 1, GOTO[SBTGInit],			c2;	bitWidth � rPixelCount LRot4,					c1, at[Or[SBTGScale.sixteenBySixteen,0C],10,SBTGScale1];	rCount � LShift1 10, SE � 1,					c2;SBTGInit:	uSBTGSrcBitWidth � bitWidth,					c3;	uSBTGLineCount � rCount, GOTO[SBTGMapSrcAndDst1],		c1;SBTGReentry:	bitWidth � uSBTGSrcBitWidth, pop,				c3;{Outer loop starts here}{Map source and destination virtual addresses}SBTGMapSrcAndDst:	rPixelCount � uSBTGPixelCount,					c1;SBTGMapSrcAndDst1:	rhVD � VD � uSBTGSrcVAHigh,					c2;	uSBTGSrcTempHigh � VD,						c3;	VD � uSBTGSrcVALow, L1 � 0,					c1;	uSBTGSrcTempLow � VD, L3 � L3.SBTGSrc,				c2;	rhTemp � DBit � uSBTGSrcBit, CALL[ComMap],			c3;{ComMap subroutine starts in c1, ends in c1};	uSBTGHold � BARealALo, BARealALo � BARealAHi, BRANCH[$,SBTGSrcFault], c2, at[L3.SBTGSrc,10,ComMapRet];	rhSrcReal � BARealALo LRot0,					c3;	DByte � uSBTGDstByte, NZeroBr, L2 � 0,				c1;	rhVD � VD � uSBTGDstVAHigh, BRANCH[$,SBTGDst1],			c2;	byteWidth � uSBTGPixelCount, GOTO[SBTGDst2],			c3;SBTGDst1:	byteWidth � uSBTGPixelCount, L2 � 2,				c3;SBTGDst2:	uSBTGDstTempHigh � VD, L3 � L3.SBTGDst,				c1;	VD � uSBTGDstVALow, L1 � 1,					c2;	uSBTGDstTempLow � VD, CALL[ComMapByte],				c3;{ComMapByte subroutine starts in c1, ends in c1};	rSrcReal � uSBTGHold, BRANCH[$,SBTGDstFault],			c2, at[L3.SBTGDst,10,ComMapRet];	rDstReal � BARealALo,						c3;	BARealALo � BARealAHi,						c1;	rhDstReal � BARealALo LRot0,					c2;	rCount � RShift1 uSBTGLineCount, XLDisp,			c3;{Set L5 for one of three variations on destination processing:	first time - store scaled pixels into destination directly	"middle" times - add scaled pixels to destination (for a running total)	last time - add scaled pixels to destination, and normalize if scaleFactor = 16x16}	rCount � LShift1 rCount - 1, SE � 0, NZeroBr, BRANCH[$,SBTGFirstTime,2], c1;	uSBTGLineCount � rCount, rTemp � rhTemp, NZeroBr, L5 � 0{/1}, BRANCH[SBTGLastTime,SBTGMidTime], c2;SBTGFirstTime:	uSBTGLineCount � rCount, rTemp � rhTemp, NZeroBr, L5 � 3, CANCELBR[$,3], c2;	Data � 0, Xbus � uSBTGScale, XDisp, BRANCH[SBTGStartZ,SBTGStartNZ], c3;SBTGMidTime:	Data � 0, Xbus � uSBTGScale, XDisp, BRANCH[SBTGStartZ,SBTGStartNZ], c3;SBTGLastTime:	Data � 0, Xbus � uSBTGScale, XDisp, BRANCH[SBTGStartZ,SBTGStartNZ], c3;{If the source is word-aligned, go directly to loop}SBTGStartZ:	MAR � [rhSrcReal, rSrcReal + 0], L4 � 0, DISP4[SBTGNext],	c1;{If the source is not word-aligned, rotate the source so first pixel to be processed is left-justified; also calculate number of pixels remaining in word}SBTGStartNZ:	MAR � [rhSrcReal, rSrcReal + 0], L4 � 0, DISP4[SBTGSet],	c1;	rPPW � 11 - rTemp, GOTO[SBTGSetRet],				c2, at[SBTGScale.twoByTwo,10,SBTGSet];	rPPW � 13 - rTemp, GOTO[SBTGSetRet],				c2, at[SBTGScale.fourByFour,10,SBTGSet];	rPPW � RShift1 rTemp xor 8, GOTO[SBTGSetRet],			c2, at[SBTGScale.eightByEight,10,SBTGSet];	GOTO[SBTGSetRet],						c2, at[SBTGScale.sixteenBySixteen,10,SBTGSet];SBTGSetRet:	Q � MD, CALL[LRotateN],						c3;{LRotateN subroutine starts in c1, ends in c2}	rTemp � rTemp and ~rMaskN, L4Disp,				c3, LRotateNRet[L0.SBTG];	rPPW � RShift1 rPPW, SE � 0, DISP2[SBTGStart],			c1;	GOTO[SBTGStartLoop],						c2, at[SBTGScale.twoByTwo,4,SBTGStart];	rPPW � RShift1 rPPW, SE � 0, GOTO[SBTGStartLoop],		c2, at[SBTGScale.fourByFour,4,SBTGStart];	rPPW � DARShift1 rPPW + 2, LOOPHOLE[niblTiming], GOTO[SBTGStartLoop], c2, at[SBTGScale.eightByEight,4,SBTGStart];	rPPW � 1,							c2, at[SBTGScale.sixteenBySixteen,4,SBTGStart];SBTGStartLoop:	rPixelCount � uSBTGPixelCount, L4Disp, CALL[SBTGCountBits],	c3;{Start of loop, if on low byte}{SBTGCountBits starts in c1, ends in c1}	Data � rCount, L2 � 0,						c2, at[2,10,SBTGCtRet];	rPixelCount � rPixelCount - 1, ZeroBr,				c3;	MAR � [rhDstReal, rDstReal + 0], L5Disp, BRANCH[$,SBTGReadDstLowByteOnly], c1;{loop starts on low byte and continues: leave L2 set to 0}	rCount � ~0FF, DISP4[SBTGOneByte,4],				c2;{Inner loop starts here - count bits for high byte of destination word}{SBTGCountBits starts in c1, ends in c1}SBTGLineLoop:	rPixelCount � rPixelCount - 1, ZeroBr, L2 � 1,			c2, at[0,10,SBTGCtRet];	Data � rCount LRot8, BRANCH[SBTGLoopA,SBTGReadDstHighByteOnly],	c3;{SBTGLoopA:	Noop,								c1;	rPPW � rPPW - 1, ZeroBr,					c2;	L4Disp, BRANCH[SBTGCountBits,SBTGNextSrc],			c3;}{Count bits for low byte of destination word}{SBTGCountBits/SBTGNextSrc starts in c1, ends in c1}	rPixelCount � rPixelCount - 1, ZeroBr, L2 � 0,			c2, at[1,10,SBTGCtRet];	Data � Data or rCount, L5Disp, BRANCH[SBTGReadDst,SBTGLastWord], c3;SBTGReadDst:	MAR � [rhDstReal, rDstReal + 0], L2Disp, DISP2[SBTGWD],		c1;{first time: write data directly to destination}	MDR � Data, BRANCH[SBTGIncrDst,SBTGNextLine,3],			c2, at[3,4,SBTGWD];{middle times: read destination word and add to data}	CANCELBR[$,5],							c2, at[1,4,SBTGWD];	Q � MD,								c3, at[5,10,SBTGOneByte];SBTGWriteDst:	MAR � [rhDstReal, rDstReal + 0], L2Disp, CANCELBR[$,1],		c1;	MDR � Data + Q, BRANCH[$,SBTGNextLine,3],			c2;SBTGIncrDst:	rDstReal � rDstReal + 1, PgCarryBr,				c3;SBTGLoopA:	rVirtualL � uSBTGDstTempLow, BRANCH[$,SBTGRemapDst],		c1;SBTGLoopB:	rPPW � rPPW - 1, ZeroBr,					c2;	L4Disp, BRANCH[SBTGCountBits,SBTGNextSrc],			c3;{SBTGCountBits/SBTGNextSrc starts in c1, ends in c1, returns to SBTGLineLoop above}SBTGRemapDst:	rVirtualL � rVirtualL + r0100, CarryBr,				c2;SBTGRemapDstA:	Q � rhVirtualH � uSBTGDstTempHigh, BRANCH[MapDst,$],		c3;{MapDst subroutine starts in c1, ends in c2, returns below}	Q � Q + 1,							c1;	rhVirtualH � Q LRot0,						c2;	uSBTGDstTempHigh � Q, CALL[MapDst],				c3;	uSBTGDstTempLow � rVirtualL,					c3, MapDstRet[L0.SBTG];	rDstReal � rDstReal and ~0FF, GOTO[SBTGLoopB],			c1;{last time: read destination word, add to data, and if 16x16 do normalization}SBTGLastCheck:	[] � uSBTGScale xor SBTGScale.sixteenBySixteen, NZeroBr, CANCELBR[$,7], c2, at[0,4,SBTGWD];	Q � MD, XRefBr, BRANCH[$,SBTGWriteDst],				c3;{Normalization: if a pixel is >= 80H, subtract 1}{The maximum value for either byte of Data is 16. Thus, if the low byte addition is going to carry, the destination word read in must be greater than 80H, and we'll catch it via the above XRefBr test.}	Data � Data + Q, CarryBr, BRANCH[$,SBTGAdjustLow],		c1;{Low byte of dest word was < 80H, but still need to test sum.}	Xbus � Data LRot0, XRefBr, BRANCH[SBTGDstNoC,SBTGDstC],		c2;{Low byte of dest word was >= 80H: do normalization (which will undo low byte carry if it occurred)}SBTGAdjustLow:	Data � Data - 1, BRANCH[SBTGDstNoC,SBTGDstC],			c2;{Test high byte for >= 80H}SBTGDstNoC:	[] � Data, NegBr, BRANCH[SBTGWDA,SBTGWDB],			c3;{High byte carry: do normalization (which will undo carry)}SBTGDstC:	Data � Data - r0100, BRANCH[SBTGWDA,SBTGWDB],			c3;{Low byte of sum < 80H (or already decremented)}SBTGWDA:	MAR � [rhDstReal, rDstReal + 0], L2Disp, BRANCH[$,SBTGWDC],	c1;{High byte of sum < 80H (or already decremented)}	MDR � Data, BRANCH[SBTGIncrDst,SBTGNextLine,3],			c2;{High byte of sum >= 80H: do normalization}SBTGWDC:	MDR � Data - r0100, BRANCH[SBTGIncrDst,SBTGNextLine,3],		c2;{Low byte of sum >= 80H: do normalization}SBTGWDB:	MAR � [rhDstReal, rDstReal + 0], L2Disp, BRANCH[$,SBTGWDD],	c1;{High byte of sum < 80H (or already decremented)}	MDR � Data - 1, BRANCH[SBTGIncrDst,SBTGNextLine,3],		c2;{High byte of sum >= 80H: do double normalization}SBTGWDD:	MDR � Data - r0100 - 1, BRANCH[SBTGIncrDst,SBTGNextLine,3],	c2;{End-of-loop conditions}{loop starts and ends on low byte: set L2 to >= 4}SBTGReadDstLowByteOnly:	rCount � ~0FF, L2 � 4, DISP4[SBTGOneByte,4],			c2;{Loop ends on high byte: set L2 to >= 4}SBTGReadDstHighByteOnly:	MAR � [rhDstReal, rDstReal + 0], L5Disp,			c1;	rCount � 0FF, L2 � 4, DISP4[SBTGOneByte,4],			c2;{Loop ends on low byte: set L2 to 4}SBTGLastWord:	CANCELBR[$,3],							c1;	L2 � 4,								c2;	L5Disp, GOTO[SBTGReadDst],					c3;{One-byte processing}{first time: read unaffected destination byte and add to data}	Q � MD and rCount, GOTO[SBTGWriteDst],				c3, at[7,10,SBTGOneByte];{middle times: same as two-byte case (dispatch target at SBTGWriteDst-1)}{last time: read destination word, add to data, and if 16x16 do one-byte normalization}	Q � MD,								c3, at[4,10,SBTGOneByte];	[] � uSBTGScale xor SBTGScale.sixteenBySixteen, ZeroBr,		c1;	[] � rCount and 1, ZeroBr, BRANCH[$,SBTGOneByteLastLine],	c2;	CANCELBR[SBTGWriteDst,1],					c3;SBTGOneByteLastLine:	BRANCH[SBTGHighByteLastLine,SBTGLowByteLastLine],		c3;{Normalization: if a pixel is >= 80H, subtract 1}{High byte only: check for carry, then go to two-byte case (skip low tests)}SBTGHighByteLastLine:	Data � Data + Q, CarryBr,					c1;	BRANCH[SBTGDstNoC,SBTGDstC],					c2;{Low byte only: check for page carry or >= 80H, then go to two-byte case (skip high tests)}SBTGLowByteLastLine:	Data � Data + Q, PgCarryBr,					c1;	Xbus � Data LRot0, XRefBr, BRANCH[$,SBTGDstPC],			c2;	BRANCH[SBTGWDA,SBTGWDB],					c3;{page carry: force normalization}SBTGDstPC:	CANCELBR[SBTGWDB,1],						c3;{End of inner loop: check for last line, and if not, advance source to next line}SBTGNextLine:	rwrdaddl � uSBTGSrcVALow, L5Disp,				c3;	rwrdaddh � uSBTGSrcVAHigh, BRANCH[SBTGDone,$,2],		c1;	bitnum � uSBTGSrcBit, L4 � L4.SBTG,				c2;	offset � uSBTGSrcBPL, CALL[BBASubEntry],			c3;{BumpBitAddress subroutine starts in c1, ends in c2}	uSBTGSrcVALow � rwrdaddl,					c3, at[L4.SBTG,10,BumpBitAddressRet];{Store new source address and check for interrupts}	uSBTGSrcVAHigh � rwrdaddh, MesaIntBr,				c1;	uSBTGSrcBit � bitnum, BRANCH[$,SBTGInt],			c2;	bitWidth � uSBTGSrcBitWidth, GOTO[SBTGMapSrcAndDst],		c3;SBTGInt:	TOS � uSBTGSrcBitWidth, GOTOABS[Bank2Interrupt],		c3;{Fault returns from calls to ComMap}SBTGSrcFault:	uFaultParm0 � VD, GOTO[SBTGFault],				c3;SBTGDstFault:	uFaultParm0 � VD,						c3;SBTGFault:	VD � rhVD,							c1;	uFaultParm1 � VD,						c2;	T � Q,								c3;	TOS � uSBTGSrcBitWidth,						c1;	GOTOABS[Bank2Fault],						c2;{Done, set stackP to 0 and return}SBTGDone:	Noop,								c2;SBTGEnd:	stackP � 0, CANCELBR[$,3],					c3;	Bank � bank0, GOTOABS[Bank2NxtInstc2],				c1;{internal subroutines}{Read next source word, initialize pixels-per-word count, and check for page cross}SBTGNextSrc:	MAR � rSrcReal � [rhSrcReal, rSrcReal + 1], DISP2[SBTGNext],	c1;	rPPW � 8, BRANCH[SBTGReadSrc,SBTGRemapSrc,1],			c2, at[SBTGScale.twoByTwo,4,SBTGNext];	rPPW � 4, BRANCH[SBTGReadSrc,SBTGRemapSrc,1],			c2, at[SBTGScale.fourByFour,4,SBTGNext];	rPPW � 2, BRANCH[SBTGReadSrc,SBTGRemapSrc,1],			c2, at[SBTGScale.eightByEight,4,SBTGNext];	rPPW � 1, BRANCH[SBTGReadSrc,SBTGRemapSrc,1],			c2, at[SBTGScale.sixteenBySixteen,4,SBTGNext];SBTGReadSrc:	rTemp � MD, L4Disp, GOTO[SBTGCountBits],			c3;SBTGRemapSrc:	rVirtualL � uSBTGSrcTempLow,					c3;	rVirtualL � rVirtualL + r0100, CarryBr,				c1;	Q � rhVirtualH � uSBTGSrcTempHigh, BRANCH[$,SBTGRemapSrcB],	c2;SBTGRemapSrcA:	rVirtualL � rVirtualL and ~0FF, CALL[MapSrc],			c3;{MapSrc subroutine starts in c1, ends in c2, returns below}SBTGRemapSrcB:	Q � Q + 1,							c3;	rhVirtualH � Q LRot0,						c1;	uSBTGSrcTempHigh � Q, GOTO[SBTGRemapSrcA],			c2;	uSBTGSrcTempLow � rVirtualL, rTemp � MD, L4Disp,		c3, MapSrcRet[L0.SBTG];{Count number of "1" bits in current pixel: count starts at -2 for 2x2 masked case}SBTGCountBits:	rCount � -2, DISP4[SBTGCtRet,0C],				c1;	rTemp � LShift1 rTemp, SE � 0, Xbus � rTemp LRot4, XDisp,	c2, at[Or[SBTGScale.twoByTwo,0C],10,SBTGCtRet];	rTemp � rTemp + rTemp, L2Disp, DISP4[SBTGCt2,3],		c3;	rTemp � rTemp LRot4, XDisp,					c2, at[Or[SBTGScale.fourByFour,0C],10,SBTGCtRet];	rCount � rCount + 2, L2Disp, DISP4[SBTGCt2],			c3;	rTemp � rTemp LRot4, XDisp,					c2, at[Or[SBTGScale.eightByEight,0C],10,SBTGCtRet];	Xbus � SBTGMaskedScale.fourByFour, XDisp, DISP4[SBTGCt2],	c3;	rTemp � rTemp LRot4, XDisp,					c2, at[Or[SBTGScale.sixteenBySixteen,0C],10,SBTGCtRet];	Xbus � 0B, XDisp, DISP4[SBTGCt2],				c3;	rTemp � rTemp LRot4, XDisp,					c2, at[0B,10,SBTGCtRet];	Xbus � SBTGMaskedScale.eightByEight, XDisp, DISP4[SBTGCt2],	c3;{Add appropriate number of "1" bits to count}	rCount � rCount + 0, DISP4[SBTGCtRet],				c1, at[0,10,SBTGCt2];	rCount � rCount + 1, DISP4[SBTGCtRet],				c1, at[1,10,SBTGCt2];	rCount � rCount + 1, DISP4[SBTGCtRet],				c1, at[2,10,SBTGCt2];	rCount � rCount + 2, DISP4[SBTGCtRet],				c1, at[3,10,SBTGCt2];	rCount � rCount + 1, DISP4[SBTGCtRet],				c1, at[4,10,SBTGCt2];	rCount � rCount + 2, DISP4[SBTGCtRet],				c1, at[5,10,SBTGCt2];	rCount � rCount + 2, DISP4[SBTGCtRet],				c1, at[6,10,SBTGCt2];	rCount � rCount + 3, DISP4[SBTGCtRet],				c1, at[7,10,SBTGCt2];	rCount � rCount + 1, DISP4[SBTGCtRet],				c1, at[8,10,SBTGCt2];	rCount � rCount + 2, DISP4[SBTGCtRet],				c1, at[9,10,SBTGCt2];	rCount � rCount + 2, DISP4[SBTGCtRet],				c1, at[0A,10,SBTGCt2];	rCount � rCount + 3, DISP4[SBTGCtRet],				c1, at[0B,10,SBTGCt2];	rCount � rCount + 2, DISP4[SBTGCtRet],				c1, at[0C,10,SBTGCt2];	rCount � rCount + 3, DISP4[SBTGCtRet],				c1, at[0D,10,SBTGCt2];	rCount � rCount + 3, DISP4[SBTGCtRet],				c1, at[0E,10,SBTGCt2];	rCount � rCount + 4, DISP4[SBTGCtRet],				c1, at[0F,10,SBTGCt2];