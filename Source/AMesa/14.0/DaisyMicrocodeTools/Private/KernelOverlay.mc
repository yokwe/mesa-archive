{ --	Copyright (C) 1984 by Xerox Corporation.  All rights reserved. -- -- KernelOverlay.mc, AYC   ,  7-Nov-84 18:43:49 -- -- This piece of microcode will be overlaid in ABS[0FE0,0FFF]. -- It contains all the code necessary to read/write most of the registers in the Sirius -- except the Link registers. -- -- Link registers read/write routines are overlaid on top of each other, i.e. Link registers -- cannot be read-write consecutively without overlaying the apporiate code in ABS[0FEF,0FF] -- -- Map registers read/write are in one code segment separate from KernelOverlay.mc --}Reserve[0,0FDF];{ -- -- to Write to a Sirius register: -- -- write the microcode instruction --	any register � MD at RDestination[0FE1], GOTO[Return] -- then, start Sirius with --     NIA = WriteState[0FE0], NIAp2Hold = WriteState+1[0FE1 or RDestination] --}WriteState:	MAR � aMailBox, Read, c1, at[0FE0];	Noop, c2, at[0FE1];RDestination:	Noop, GOTO[Wait], c3, at[0FE2];	{	 --	 -- all possible Rbus Destination	 --	CSBank � MD, GOTO[Return];	dKernel � MD, GOTO[Return];	STK[] � MD, GOTO[Return];	StkP � MD, GOTO[Return];	RTC.high � MD, GOTO[Return];	RTC.low � MD, GOTO[Return];	Prescaler � MD, GOTO[Return];	aMailBox.low � MD, GOTO[Return];	aMailBox.page � MD, GOTO[Return];	rdKernelSave � MD, GOTO[Return];	Q � MD, GOTO[Return];	CIP � MD, GOTO[Return];	}	{ -- -- to Read to a Sirius register from ABus Source: -- -- write the microcode instruction --	MD � ASource at ASource[0FE4], GOTO[Return] -- then, start Sirius with --	NIA = WriteState[0FE3], NIAp2Hold = WriteState+1[0FE4 or ASource] --}ReadABus:	MAR � aMailBox, Write, c1, at[0FE3];ASource:	MDR � ChipVersionNo, GOTO[Return], c2, at[0FE4];	{	 --	 -- all possible ABus Sources	 --	MDR � CSBank, GOTO[Return];	MDR � dKernel, GOTO[Return];	MDR � STK[0], GOTO[Return];	MDR � StkP, GOTO[Return];	MDR � RTC.high, GOTO[Return];	MDR � RTC.low, GOTO[Return];	MDR � Prescaler, GOTO[Return];	MDR � CIP, GOTO[Return];	MDR � ChipVersionNo, GOTO[Return];	MDR � aMailBox.low, GOTO[Return];	MDR � aMailBox.page, GOTO[Return];	MDR � ibCtr, GOTO[Return];	}	{ -- -- to Read to a Sirius register from BBus Source: -- -- write the microcode instruction --	MD � ASource at ReadBBus[0FE5], GOTO[ReadBBus+1] -- then, start Sirius with --	NIA = ReadBBus[0FE5], NIAp2Hold = ReadBBus+1[0FE6] --}ReadBBus:	Noop, at[0FE5];	{	 --	 -- all possible BBus Sources	 --	dKernel � rdKernelSave;	dKernel � Q;	dKernel � ib;	}	MAR � aMailBox, Write, c1, at[0FE6];	MDR � dKernel, GOTO[Return], c2, at[0FE7];	{ -- -- to Read to a Sirius Link Register(n): -- -- write the microcode instruction --	any LnDisp at ReadLink[0FE8], GOTO[ReadLink+1] -- then, start Sirius with --	NIA = ReadLink[0FE8], NIAp2Hold = ReadLink+1[0FE9] --}ReadLink:	Noop, {LnDisp;   substitute LnDisp for n IN[0..4) }, at[0FE8];	Noop, DISP4[LinkBase], at[0FE9];	WriteMBox:	MAR � aMailBox, Write, c1, at[0FEA];	MDR � dKernel, GOTO[Return], c2, at[0FEB];Return:	Noop, GOTO[Wait], c3, at[0FEC];Wait:	Noop, GOTO[Wait], at[0FED];PopIB:	Noop, PopIB, GOTO[Wait], at[0FEE];	Noop, at[0FEF];LinkBase: 	dKernel � 0, GOTO[WriteMBox], at[0FF0];{ -- Note: The following portions of "Write Link Register" and "Read Link Register" will be --	assembled separately.  When one of the two (Read or Write) is called for, then that --	code segment is MANDATORILY overlaid on top of the other. --}{ -- -- to Write to a Sirius Link Register(n): -- -- write the microcode instruction --	any Ln � c at LinkTable+c[0FEF+c], GOTO[LinkTable+c+1 or 0FEF+c+1] -- then, start Sirius with --	NIA = LinkTable+c[0FEF+c], NIAp2Hold = LinkTable+c+1[0FEF+c+1] --}{LinkTable:	Noop, GOTO[Wait], {Ln � 0}, at[0FEF];	Noop, GOTO[Wait], {Ln � 1}, at[0FF0];	Noop, GOTO[Wait], {Ln � 2}, at[0FF1];	Noop, GOTO[Wait], {Ln � 3}, at[0FF2];	Noop, GOTO[Wait], {Ln � 4}, at[0FF3];	Noop, GOTO[Wait], {Ln � 5}, at[0FF4];	Noop, GOTO[Wait], {Ln � 6}, at[0FF5];	Noop, GOTO[Wait], {Ln � 7}, at[0FF6];	Noop, GOTO[Wait], {Ln � 8}, at[0FF7];	Noop, GOTO[Wait], {Ln � 9}, at[0FF8];	Noop, GOTO[Wait], {Ln � A}, at[0FF9];	Noop, GOTO[Wait], {Ln � B}, at[0FFA];	Noop, GOTO[Wait], {Ln � C}, at[0FFB];	Noop, GOTO[Wait], {Ln � D}, at[0FFC];	Noop, GOTO[Wait], {Ln � E}, at[0FFD];	Noop, GOTO[Wait], {Ln � F}, at[0FFE];	Noop, GOTO[Wait], at[0FFF];}{LinkBase:	dKernel � 0, GOTO[WriteMBox], at[0FF0];	dKernel � 1, GOTO[WriteMBox], at[1, 10, LinkTable];	dKernel � 2, GOTO[WriteMBox], at[2, 10, LinkTable];	dKernel � 3, GOTO[WriteMBox], at[3, 10, LinkTable];	dKernel � 4, GOTO[WriteMBox], at[4, 10, LinkTable];	dKernel � 5, GOTO[WriteMBox], at[5, 10, LinkTable];	dKernel � 6, GOTO[WriteMBox], at[6, 10, LinkTable];	dKernel � 7, GOTO[WriteMBox], at[7, 10, LinkTable];	dKernel � 8, GOTO[WriteMBox], at[8, 10, LinkTable];	dKernel � 9, GOTO[WriteMBox], at[9, 10, LinkTable];	dKernel � 0A, GOTO[WriteMBox], at[0A, 10, LinkTable];	dKernel � 0B, GOTO[WriteMBox], at[0B, 10, LinkTable];	dKernel � 0C, GOTO[WriteMBox], at[0C, 10, LinkTable];	dKernel � 0D, GOTO[WriteMBox], at[0D, 10, LinkTable];	dKernel � 0E, GOTO[WriteMBox], at[0E, 10, LinkTable];	dKernel � 0F, GOTO[WriteMBox], at[0F, 10, LinkTable];}