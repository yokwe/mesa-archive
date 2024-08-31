{ ComMapSub.mcCreated on: 18-Jul-86  8:58:18 by Mark ReinhartLast Edited by John Monahan,  3-Dec-86 11:58:59: remove use of some temp regs, tighten up loopsLast Edited by Mark Reinhart, 9-Oct-86 15:59:58: removed cycles around MapDstPage, MapsrcPage and DstmapOK, SrcMapOk.Last Edited by John Monahan, 12-Aug-86 16:56:49Byte and Word routines added by Martin J. Shramo, 7-Aug-86 11:02:55	this file lists well with the following XDE Executive command:		>print gacha8/f /-a ComMapSub.mc}{************************************************************************************************	ComMap  SUBROUTINE	first cycle = c1 , last cycle = c1	This routine pulls source or destination pages into real memory starting at a specified address and continuing for a specified number of bits.  If all pages are mapped, the real address of the original virtual address is returned.  If there is a page that is not mapped, an error return is followed.  (There are also alternate entry points for byte and word counts.)	CALLING ARGUMENTSL1		Src/Dst mapping flag (0/1)	(Link Reg 1)L3		caller				(Link Reg 3)bitWidth	bit count			(R 02)(byteWidth	byte count, for ComMapByte	(R 02))(wordWidth	word count, for ComMapWord	(R 02))VD		working virtual lo address 	(R 01)rhVD		working virtual hi address	(RH 01)DBit		bit offset			(R 09)(DByte		byte offset, for ComMapByte	(R 09))	always RETURNS for first mapped pageBARealALo	real address page and word	(R 0C)BARealAHi	real address rh 		(RH 0C)	uses as a tempL1		runin flag (0/1 first page, 2/3 subsequent)	(Link Reg 1)Q		working real address page and wordRegb		ITEM width in pages 		(R 0B)	RETURNS THRUComMapRet		 ***  if a page fault occurs returns through ComMapRet ***  ************************************************************************************************}ComMap: Regb � VD and 0FF					,c1; {get current page offset, words}	Regb � Regb LRot4					,c2; {get current page offset, bits}	Regb � Regb + DBit					,c3; {adjust for bit offset in word}	Regb � Regb + 0F					,c1; {round up to include partial word}	Regb � DARShift1 Regb + bitWidth			,c2; {get total # bits from page start / 2}	Regb � Regb and ~7					,c3; {truncate to word boundary}	Regb � LRot1 Regb					,c1;	Regb � Regb LRot12, GOTO[ComMapTestCount]		,c2; {get word count in low 13 bits}ComMapByte:	Regb � VD and 0FF					,c1; {get current page offset, words}	Regb � Regb LShift1, SE � 0				,c2; {get current page offset, bytes}	Regb � Regb + DByte + 1					,c3; {adjust for byte offset in word, round up to include partial word}	Regb � DARShift1 Regb + byteWidth			,c1; {get total # bytes from page start / 2}	GOTO[ComMapTestCount]					,c2;ComMapWord:	Regb � VD and 0FF					,c1; {get current page offset, words}	Regb � Regb + wordWidth					,c2; {get total # words from page start}{common code for all cases}ComMapTestCount:	[] � Regb, ZeroBr					,c3;	Regb � Regb + 0FF, BRANCH[$,ComMapZeroWords]		,c1; {round up to include partial page}	Regb � Regb LRot8, GOTO[ComMapMaskHighByte]		,c2; {get page count in low byte}ComMapZeroWords:	Regb � 1						,c2; {must map at least one page}ComMapMaskHighByte:	Regb � Regb and 0FF					,c3; {mask off high byte}MapPage:Map � [rhVD, VD]					,c1;	L1Disp							,c2;	Q � MD, DISP4[pageMap, 0E]				,c3;	[] � Q LRot0, XWtOKDisp					,c1, at[0F, 10, pageMap ];dstMapRef:BRANCH[$, DstMapOK, 0D]       			,c2;	[] � Q LRot0, XwdDisp					,c3;	Map � [rhVD, VD], DISP2[updstMapHere]			,c1;updstMapHere:MDR � Q or map.rd, GOTO[DstMapOK]			,c2, at[0,4,updstMapHere];	Q � qWriteProtect, GOTO[pageFault]			,c2, at[1,4,updstMapHere];	MDR � Q or map.rd, GOTO[DstMapOK]			,c2, at[2,4,updstMapHere];	Q � qPageFault, GOTO[pageFault]				,c2, at[3,4,updstMapHere];DstMapOK:L1Disp, GOTO[MapOTay]					,c3;	[] � Q LRot0, XRefBr  					,c1, at[0E, 10, pageMap ];SrcMapRef:BRANCH[$, SrcMapOK]					,c2;	[] � Q LRot0, XwdDisp					,c3;	Map � [rhVD, VD], DISP2[upSrcMapHere]			,c1;upSrcMapHere:MDR � Q or map.referenced, GOTO[SrcMapOK]		,c2, at[0,4,upSrcMapHere];	MDR � Q or map.referenced, GOTO[SrcMapOK]		,c2, at[1,4,upSrcMapHere];	MDR � Q or map.referenced, GOTO[SrcMapOK]		,c2, at[2,4,upSrcMapHere];	Q � qPageFault, GOTO[pageFault]				,c2, at[3,4,upSrcMapHere];SrcMapOK:L1Disp, GOTO[MapOTay]					,c3;MapOTay:BRANCH[$, ComMapTestForDone, 0D]			,c1; {test runin flag}	BARealALo � Q, BARealAHi � Q LRot0			,c2; {if runin, get first RA}	L1Disp							,c3;	MAR � BARealALo � [BARealAHi, VD+0], L1 � 0E, BRANCH[$, ComMapTestForDone, 0E] ,c1;	Regb � Regb - 1, ZeroBr, GOTO[incVA]			,c2;ComMapTestForDone:	Regb � Regb - 1, ZeroBr					,c2;incVA:	Q � 0FF + 1, L3Disp, BRANCH[$, Done]       		,c3;	VD � VD + Q, CarryBr, CANCELBR[$,0F]	       		,c1; {add one page to lo addr}	Q � rhVD + 1, LOOPHOLE[byteTiming], BRANCH[$, incrhReg]	,c2; {increment hi addr in case there's a carry}	GOTO[MapPage]						,c3;incrhReg:	rhVD � Q LRot0, GOTO[MapPage]				,c3; {store incremented hi addr}pageFault:	VD � VD and ~0FF, L3Disp				,c3; {return unmapped Virt page addr}	Xbus � 1, XDisp, DISP4[ComMapRet]			,c1;Done:	Xbus � 0, XDisp, DISP4[ComMapRet]			,c1;