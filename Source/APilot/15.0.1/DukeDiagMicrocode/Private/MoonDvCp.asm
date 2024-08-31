$MOD186$PAGELENGTH (72)$PAGEWIDTH  (136);Copyright (C) 1987 by Xerox Corporation. All rights reserved.;-- MoonDvCp.asm;-- last edited by:;--  HEM   5-Feb-87 12:30:11 ;fixed JMP SHORT DybrkCPConditioning instr;--  HEM  31-Jan-87 20:18:32 ;adapted to diagnostics structure;--  RDH  22-Jan-86 12:06:22 ;Create from parts of RAMBoot.asm and DazeBoot.asm. ;This file contains general Dove code to allow loading of diagnostic;overlays that contain microcode.NAME			DoveCP;--------------------------------------------------------------------------------;$NOLIST;$INCLUDE		(EthHdFce.asm)	$INCLUDE		(HardDefs.asm)	$INCLUDE		(IOPDefs.asm)	$INCLUDE		(IOPMacro.asm)$INCLUDE		(RAMBDefs.asm)	;$INCLUDE		(EthBDefs.asm)	;$INCLUDE		(Handlers.asm)	;to resolve handler IDs$INCLUDE		(CSBankDf.asm)	$INCLUDE		(RAMEEP.asm)$INCLUDE		(MoonLink.def)	;diagnostic location info$LIST;--------------------------------------------------------------------------------EXTRN			mesaProcessorInterrupt :ABS;--------------------------------------------------------------------------------BootStrapIOR		SEGMENT	COMMONEXTRN			IncSIFarProc: WORD	EXTRN			WriteCSProc: WORD	EXTRN			CPStartOrInitProc: WORD	EXTRN			CPType: BYTE	EXTRN			csBankConfiguration: BYTE	BootStrapIOR		ENDS;--------------------------------------------------------------------------------IOPEInRAM		SEGMENT		PUBLICORG	MnDgDvCpLoc			ASSUME	CS:IOPEInRAM			ASSUME	DS:BootStrapIOR;--------------------------------------------------------------------------------PUBLIC			InitCPSpecificPUBLIC			LoadAXFromBootBufPUBLIC			LoadAXFromBootBufLateEntryPUBLIC			LoadCXFromBootBufPUBLIC			LoadCXFromBootBufLateEntryPUBLIC			CallDumpCSAddrBlockEXTRN	DybrkCPConditioning: NEAREXTRN	DaisyCPConditioning: NEAREXTRN	WriteDybrkControlStore: NEAREXTRN	WriteDaisyControlStore: NEAREXTRN	StartDaisyCP: NEAREXTRN	InitDybrkCP: NEAREXTRN	InitDaisyCP: NEAR;InitCPSpecific;This segment of code looks up things like what type of CP we have and how many; banks of CS there are and saves them in IO Region variables.  It also; initializes pointers to the procs that will be called from RamBoot.asm in the; IO Region.  It also calls the appropriate CP conditioning proc.InitCPSpecific:	GetCSBankCfg:	%ReadEEProm(eePromMemSize, 1)	;AX � virt mem,,eeprom.		JNC	GoodEEProm		;Check eeprom validity.		MOV	AX, fourKEEPromFormat	;Default is 1 bank.GoodEEProm:	AND	AL, 0F0H		;Get rid of VM size.		MOV	csBankConfiguration, AL	;Save it for CheckBlock.		GetCPType:	IN	AX, machineIDPort	;Read port		AND	AX, machineIDMask	;Mask out other bits.		MOV	CPType, AL		;Save it for CheckBlock.		SetUpEntryPtrs:	MOV	WriteCSProc, OFFSET WriteDoveCS 		MOV	WriteCSProc+2, CS				MOV	CPStartOrInitProc, OFFSET CPStartOrInit 		MOV	CPStartOrInitProc+2, CS	PrepareCPInt:	%ThisTaskServices (mesaProcessorInterrupt,BadMesaInterrupt)		DoConditioning:	CMP	CPType, Daybreak		JE	GoToDybrkCPConditioning		;does far return to		JMP 	SHORT DaisyCPConditioning	; RamBoot's InitIOP procGoToDybrkCPConditioning:		JMP 	SHORT DybrkCPConditioning				;Initialization is done.  We are ready for CS blocks.	;-------------------------------------------------------------------------------;WriteDoveCS;This piece of code is called from Ramboot.asm in the proc ProcessCPBlock when a; CP write block is detected.  This code then checks if the block should be; ignored or loaded and calls the appropriate procs to do so depending on the; machine type.WriteDoveControlStore	PROC	FARWriteDoveCS:	CALL	CheckBlock		JC	CallDumpCS		CALL DWORD PTR	IncSIFarProc		CMP	CPType, Daybreak		JE	GoToWriteDybrkControlStore	;Does far return to ramboot.asm 		JMP SHORT WriteDaisyControlStore	;Does far returnGoToWriteDybrkControlStore:			JMP SHORT WriteDybrkControlStore	;Does far return		CallDumpCS:	MOV	CX, 5		;Prepare arg for DumpCSBlock.		CALL 	DumpCSBlock	;Move SI� to number of instructions.		CALL	LoadCXFromBootBufLateEntry		CALL	DWORD PTR IncSIFarProc				MOV	AX, CSwordByteSize	;Compute number of bytes left in		MUL	CX			; this CPWrite block.		MOV	CX, AX			;Prepare CX for DumpCSBlock.		CALL	DumpCSBlock		RET				;To ramboot.asm		WriteDoveControlStore	ENDP		;-------------------------------------------------------------------------------;CPStartOrInit;This piece of code is called from Ramboot.asm in the proc ProcessCPBlock when a; CP Start block or a CP Init block is detected.  This code checks if the block; should be ignored or loaded, checks which kind of block it is and calls the; appropriate procs to do so depending on the machine type.CPStartOrInitialize	PROC	FARCPStartOrInit:	SHL	AH, oneBit		;Sure, but which one is it?		JC	ItsStartCP		;Go process a CP Start block!		JMP	SHORT InitializeCP	;Go process a CP Initialize block!ItsStartCP:	CALL	CheckBlock		JC	CallDumpCSAddrBlock		CMP	CPType, Daybreak		JE	CallDumpCSAddrBlock	;Daybreak does not use Start addr.		JMP 	SHORT StartDaisyCP	;Does far returnInitializeCP:	CALL	CheckBlock		JC	CallDumpCSAddrBlock		CMP	CPType, Daybreak		JE	GoToInitDybrkCP				JMP 	SHORT InitDaisyCP	;Does far returnGoToInitDybrkCP:		JMP 	SHORT InitDybrkCP	;Does far returnCallDumpCSAddrBlock:		MOV	CX, 5			;Prepare arg for DumpCSBlock.		CALL 	DumpCSBlock		RET				CPStartOrInitialize	ENDP;-------------------------------------------------------------------------------;CheckBlock;--------------  Assume parameter locations upon entry into this procedure	;--------------  are as follows:;-------------- ;--------------|								|;--------------|	ES:[BX][SI]  	low order byte of block type		|;--------------|	AL		high order byte of block type		|;--------------|	AH		z0fg00b0	where			|;--------------|	 	z = Daisy/Daybreak				|;--------------|	 	fg = control store bank configuration		|;--------------|	 	b = CPAddr/CPWrite	High bit of operation	|;--------------|								|;--------------|	fg is interpreted as follows:				|;--------------|	0 => load for any cs configuration			|;--------------|	1 => load for 4K only 					|;--------------|	2 => load for 8K only 					|;--------------|								|;--------------|--------							|;--------------|								|;--------------| Upon return:							|;--------------|	IF config matches AND Machine type matches THEN		|;--------------|	  Return Carry Clear					|;--------------|	ELSE							|;--------------|	  Return Carry Set					|;--------------|	  							|;--------------|	AX smashed						|;--------------|	DL smashed						|;-------------------------------------------------------------------------------;CheckBlock checks if the given block should be dumped on the floor either for; reasons of being for the wrong bank configuration or the wrong CP type.  It; returns with the Carry bit set if the block should be dumped.  It does not dump; the block itself. CheckBlock	PROC	NEARDoCheckBlock:	MOV	DL, bankConfigMask		AND	DL, AH		JZ	ConfigMatches		;If any config is ok then return.		XOR 	DL, csBankConfiguration		JE	ConfigMatches		;If match then check machine type.DontWantThisBlock:		STC				;Return to dump block		RETConfigMatches:					SHL	AX, oneBit				JC	DybrkBlockDaisyBlock:	MOV	AL, Daisy		JMP SHORT CheckCPTypeDybrkBlock:	MOV	AL, DaybreakCheckCPType:	CMP	AL, CPType		;CPType set up by CP specific init		JNE	DontWantThisBlock	;Return to dump blockBlockIsOk:	CLC				;Return that block is OK		RET		CheckBlock	ENDP;-------------------------------------------------------------------------------DumpCSBlock	PROC	NEAR			DumpBlock:	CALL DWORD PTR	IncSIFarProc	;Bump SI with checking for end of		LOOP	DumpBlock		;boot buffer until CX runs down.		RET									DumpCSBlock	ENDP;-------------------------------------------------------------------------------;-- ;-- ;-- ;-- LoadAXFromBootBuf --.;--;This procedure just loads AX from the boot buffer byte at a time calling the; procedure IncrementSI to move the pointer along.  This assures that the end; of the boot buffer will be detected and handled correctly.;;--------------  Assume parameter locations upon entry into this procedure	;--------------  are as follows:;-------------- ;--------------|								|;--------------|	ES:[BX][SI]  	byte before the first we want		|;--------------|--------							|;--------------|								|;--------------| Upon return:							|;--------------|	ES:[BX][SI] 	2 bytes further in the stream.		|;--------------|	AX loaded from ES:[BX][SI]				|;--------------|								|;--------------|								|;-------------------------------------------------------------------------------LoadAXFromBootBuf		PROC		NEAR			CALL DWORD PTR	IncSIFarProc		;LoadAXFromBootBufLateEntry:			MOV	AH, ES: [BX][SI]	;			CALL DWORD PTR	IncSIFarProc		;			MOV	AL, ES: [BX][SI]	;			RET		LoadAXFromBootBuf		ENDP;-------------------------------------------------------------------------------;-- ;-- ;-- ;-- LoadCXFromBootBuf --.;--;This procedure just loads CX from the boot buffer byte at a time calling the; procedure IncrementSI to move the pointer along.  This assures that the end; of the boot buffer will be detected and handled correctly.;;--------------  Assume parameter locations upon entry into this procedure	;--------------  are as follows:;-------------- ;--------------|								|;--------------|	ES:[BX][SI]  	byte before the first we want		|;--------------|--------							|;--------------|								|;--------------| Upon return:							|;--------------|	ES:[BX][SI] 	2 bytes further in the stream.		|;--------------|	CX loaded from ES:[BX][SI]				|;--------------|								|;--------------|								|;-------------------------------------------------------------------------------LoadCXFromBootBuf		PROC		NEAR			CALL DWORD PTR	IncSIFarProc		;LoadCXFromBootBufLateEntry:			MOV	CH, ES: [BX][SI]	;			CALL DWORD PTR	IncSIFarProc		;			MOV	CL, ES: [BX][SI]	;			RET		LoadCXFromBootBuf		ENDP;-------------------------------------------------------------------------------BadMesaInterrupt	PROC	NEARBadMesaInt:		RET						BadMesaInterrupt	ENDPIOPEInRAM		ENDS			END