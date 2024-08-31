{File: InitDuke.mcLast Revised:JPM,  5-Dec-90  9:03:20 Add initialization of uTimerType (for sharing emulator with Bounty)TxH, 13-Sep-88 11:27:44 created from InitDaybreak.mc, with changes for VMFind microcodeJPM, 31-Dec-86 12:04:27 Add initialization of U-regs uGFI (for MDS relief) and uIdleCount*SCJ   7-Aug-86 16:25:19 Removed definition of FPTEnabled and stuck it in DualBank.dfn & SingleBank.dfn with values 2 and 0, to indicate whether or not Floating point is in uCodeJPM, 29-Jul-86 14:24:02 Remove InitDaybreak from emulator and make into initialization routineJPM, 16-Jul-86  9:50:43 Make uFactoruCode value conditional (set to FPTEnabled iff two control store banks)SCJ, 14-May-86  9:57:07 merged EIS InitDaybreak.mc with the existing InitDaybreak.mc to build a MesaDove with floating point microcodeDEG, 25-Jan-86 18:24:53 Initialize uFactoruCode and uTimesWplDispRDH, 10-Oct-85 16:03:38 Inserted ClrLOCK to test slow mode.JPM, 30-Jul-85 10:38:38 Corrected offsetMaintPanel and offsetMesaProcJPM,  3-Jul-85 11:54:16 Opie redesign conversionJPM,  4-Jun-85  8:25:28 removed u1FJPM, 11-Apr-85 17:35:31 changed value of uMaintPanel for Opie 19JPM, 13-Feb-85 13:13:55 added uMaintPanel initJGS, 18-Dec-84 13:10:51 initialized uPPMask to E000}{ 	Copyright (C) 1984, 1985, 1986, 1988, 1990 by Xerox Corporation.  All rights reserved.}StartAddress[BootTrap];Set[T0Count, 40];Set[T1Count, 41];Set[T2Count, 42];Set[T012Control, 43];Set[T0Disable, 48];Set[T0Enable, 4C];Set[T12Disable, 50];Set[T12Enable, 54];Set[T0Mode2, 34];Set[T1Mode0, 50];Set[T1Mode2, 74];Set[T2Mode2, 0B4];Set[T0InitialLSB, 035];Set[T0InitialMSB, 0C]; {0C35 hex = 3125 decimal counts = 50 milliseconds}Set[offsetMaintPanel, Lshift[8,1]];Set[offsetMesaProc, Lshift[11,1]];{Get here when the boot button is pushed, or somebody yanks on INIT/.}BootTrap: {From trap branch in Refill.mc}	ClrIntErr, ClrLOCK, CANCELBR[$,0F]  {must be c1},	c1, at[0];	ClrMPIntIOP,						c2;	G � 0, uPCCross � 0,					c3;{set up timer counters}	rhRx � T0Disable,					c1;	T � T0InitialLSB,					c2;	TT � T0Mode2,						c3;	IO � [rhRx, 0],						c1;	MDR � 0, {disable counter 0}				c2;	rhRx � T12Disable,					c3;	IO � [rhRx, 0],						c1;	MDR � 0, {disable counters 1 and 2}			c2;	rhRx � T012Control,					c3;	IO � [rhRx, 0],						c1;	MDR � TT, {set counter 0 mode},				c2;	TT � T2Mode2,						c3;	IO � [rhRx, 0],						c1;	MDR � TT, {set counter 2 mode},				c2;	rhRx � T0Count,						c3;	IO � [rhRx, 0],						c1;	MDR � T, {set counter 0 initial count LSB},		c2;	T � T0InitialMSB,					c3;	IO � [rhRx, 0],						c1;	MDR � T, {set counter 0 initial count MSB},		c2;	rhRx � T2Count,						c3;	IO � [rhRx, 0],						c1;	MDR � 0, {set counter 2 initial count LSB},		c2;	TT � T1Mode0,						c3;	IO � [rhRx, 0],						c1;	MDR � 0, {set counter 2 initial count MSB},		c2;	rhRx � T0Enable,					c3;	IO � [rhRx, 0],						c1;	MDR � 0, {enable counter 0}				c2;	rhRx � T12Enable,					c3;	IO � [rhRx, 0],						c1;	MDR � 0, {enable counters 1 and 2}			c2;	rhRx � T012Control,					c3;	IO � [rhRx, 0],						c1;	MDR � TT, {set counter 1 setup mode},			c2;	TT � T1Mode2,						c3;	IO � [rhRx, 0],						c1;	MDR � TT, {set counter 1 mode},				c2;	rhRx � T1Count,						c3;	IO � [rhRx, 0],						c1;	MDR � 0, {set counter 1 initial count LSB},		c2;	T � 1,							c3;	IO � [rhRx, 0],						c1;	MDR � 0, {set counter 1 initial count MSB}, UBrkByte � 0, c2;	uWDC � T, ClrIE, {disable interrupts}			c3;SetupConstants:{	TT � uFactoruCodeVal,					c1;	uFactoruCode � TT,					c2;	uTimesWplDisp � 0,					c3;*** uFactoruCode and uTimesWplDisp were removed since uFactoruCode clashes with uVirtPage and FPTEnabled performs the function done by uFactoruCode. uTimesWplDisp was removed since it is used only for emulating special Versatec opcodes ***}		TT � RShift1 0, SE � 1,					c1;	u8000 � TT,						c2;	TT � LShift1 0FF, SE�1,					c3;	TT � LShift1 TT, SE�1,					c1;	TT � TT LShift1, SE�1,					c2;	u7FF � TT, TT � TT LShift1, SE � 1,			c3;	TT � TT LShift1, SE � 1,				c1;	u1FFF � TT, TT � TT LShift1, SE � 1,			c2;	u3FFF � TT,						c3;	TT � 01F,						c1;	TT � TT LRot8,						c2;	TT � TT or 0F8,						c3;	uPMask � TT, {1FF8}					c1;	uPMask2 � TT,						c2;	r0100 � 0FF + 1, {0100}					c3;	TT � 0E0,						c1;	TT � TT LRot8, {E000}					c2;	uPPMask � TT,						c3;	TT � 64,						c1;	TT � TT LRot8,						c2;	UtbFlags � TT, {6400}					c3;	Q � rhIORgn � 5,					c1;	rIORgn � 20,						c2;	rIORgn � rIORgn LRot8, {IORgn real addr = 52000}	c3;	MAR � [rhIORgn, rIORgn + offsetMaintPanel],		c1;	uIORgnHigh � Q, CANCELBR[$,0],				c2;	TT � MD,						c3;	TT � TT LRot12,						c1;	TT � RShift1 TT, SE � 0,				c2;	uMaintPanel � TT,					c3;	MAR � [rhIORgn, rIORgn + offsetMesaProc],		c1;	MAPA � 4, CANCELBR[$,0], {VM map real addr = 40000H}	c2;	TT � MD,						c3;	TT � TT LRot12,						c1;	TT � RShift1 TT, SE � 0,				c2;	uMesaProc � TT,						c3;SetUpEmulatorRegs:		temp � pRunFirst,					c1;	uRunMru � temp,						c2;	uTimerType � 0,						c3;		rhT � xtFC0,						c1;	UvMDS � T � 0,						c2;	rhMDS � 0, TOS � 0,					c3;	uGFI � 0,						c1;	uIdleCountLow � 0,					c2;	uIdleCountHigh � 0,					c3;	UvG � rInt � 0,						c1;	uXTS � stackP � T, 					c2;	uWP � T, PC � T + 0 + 1{use carry}, SetMPIntIOP,	c3;	TT � 0FF LShift1, SE � 1, {1FF}				c1;	T � TT + 3{@SD[sBoot]},					c2;	uDestLo � T, L � 0, ClrMPIntIOP,			c3;{initialization done, now loop until IOP halts the CP}{emulator will resume from this address}Linkage:	GOTOABS[addrLinkage],					c1{c*}, at[addrLinkage];