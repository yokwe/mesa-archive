{File name MiscPCE.mcDescription: Special ESC codes for PC Emulation displayAuthor: JPM    Created: April 19, 1985Last edit by: JPM	 4-Dec-89 12:17:02	standardize entry & exit pointsLast edit by: SxO/TxO	12-Sep-88 15:42:01	moved to bank1Last edit by: JAC	24-Jul-85  9:59:54	fix rotation of translation tableLast edit by: JAC	22-Jul-85 17:18:35	fix order of parameters on stack}{ 	Copyright (C) 1985, 1988, 1989 by Xerox Corporation.  All rights reserved.}Set[PCEwpl, 40'd];Set[PCEwplMinus1, Sub[PCEwpl, 1]];Set[PCEcnt, Sub[100, PCEwpl]]; {stored in RH register; when incremented until    carry out of the register, we've processed the entire line}{PCEMedRes	Translate one line of PCE display to medium-resolution gray.	Parameters:		TOS = translation table (4 entries of 2x2 bits)		[STK-1, STK] = long (virtual) pointer to scratch buffer stored in rhTT,TT		[STK-3, STK-2] = long (virtual) pointer to PCE display line stored in rhT,T	Returns: none	Assumptions:		PCE display and scratch buffer are pinned in memory in contiguous real pages.}@PCEMedRes:	rhTT � STK, pop,					c1, at[0B,10,ESC8n];	TT � STK, pop,						c2;	rhT � STK, pop,						c3;	Map � [rhTT, TT], TT � TT and 0FF,			c1;	T � STK, pop,						c2;	rhTT � MD, Q � MD,					c3;	Map � [rhT, T], T � T and 0FF,				c1;	Rx � Q and ~0FF,					c2;	rhT � MD, Q � MD,					c3;	TT � TT or Rx, fXpop, push,				c1;	Rx � Q and ~0FF,					c2;	T � T or Rx,						c3;	MAR � [rhT, T + 0],					c1;	rhRio � PCEcnt, GOTO[PCEMREntry],			c2;PCEMRWordLoop:  {loop for each word in line}	MAR � [rhT, T + 0],					c1;	rhRio � Rio LRot0,					c2;PCEMREntry:	Rx � MD,						c3;	T � T + 1, Xbus � Rx LRot4, XDisp,			c1;	Rio � 1, DISP4[PCEMRBitLoop,3],				c2;	{when that leading one is shifted to the most significant bit, the word (except for one final shift) has been translated}PCEMRBitLoop0:	GOTO[PCEMRBits0],					c3, at[3,10,PCEMRBitLoop];PCEMRBitLoop1:	GOTO[PCEMRBits1],					c3, at[7,10,PCEMRBitLoop];PCEMRBitLoop2:	GOTO[PCEMRBits2],					c3, at[0B,10,PCEMRBitLoop];PCEMRBitLoop3:	GOTO[PCEMRBits3],					c3, at[0F,10,PCEMRBitLoop];PCEMRBits0:  {process each character (of 2 bits) in word}	r0100 � TOS LRot0, GOTO[PCEMRShift],			c1, at[0C,10,PCEMRBits];PCEMRBits1:	r0100 � TOS LRot4, GOTO[PCEMRShift],			c1, at[0D,10,PCEMRBits];PCEMRBits2:	r0100 � TOS LRot8, GOTO[PCEMRShift],			c1, at[0E,10,PCEMRBits];PCEMRBits3:	r0100 � TOS LRot12, GOTO[PCEMRShift],			c1, at[0F,10,PCEMRBits];PCEMRShift:	{get translation bitmap into the most significant byte for easy shift of	the top 2 translation bits into Rio and bottom 2 into Rx}	Q � r0100,						c2;	Rio � DLShift1 Rio,					c3;	Rio � DLShift1 Rio, Xbus � Rio LRot0, XHDisp,		c1;	Rx � DLShift1 Rx, Xbus � Rx LRot4, XDisp, BRANCH[$,PCEMRBitsDone,2], c2;	Rx � DLShift1 Rx, DISP4[PCEMRBits,0C],			c3;PCEMRBitsDone:	Rx � DLShift1 Rx, CANCELBR[$,0F],			c3;	MAR � [rhTT, TT + 0],					c1;	MDR � Rio, Rio � rhRio + 1, PgCarryBr,			c2;	TT � TT + PCEwpl, BRANCH[$,PCEMRWordsDone],		c3;	MAR � [rhTT, TT + 0],					c1;	MDR � Rx,						c2;	TT � TT - PCEwplMinus1, GOTO[PCEMRWordLoop],		c3;PCEMRWordsDone:	MAR � [rhTT, TT + 0],					c1;	MDR � Rx, TOS � STK, pop,				c2;	r0100 � 0FF + 1, GOTOABS[Bank1NxtInstc1],		c3;{-------------------------------------------------------------------------}{Catch unused landing spots.}{@a214:	PC � PC - 1, GOTO[ESCb],				c1, at[0C,10,ESC8n];@a215:	PC � PC - 1, GOTO[ESCb],				c1, at[0D,10,ESC8n];@a216:	PC � PC - 1, GOTO[ESCb],				c1, at[0E,10,ESC8n];@a217:	PC � PC - 1, GOTO[ESCb],				c1, at[0F,10,ESC8n];}