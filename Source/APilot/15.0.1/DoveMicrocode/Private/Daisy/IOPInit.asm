$MOD186$PAGELENGTH (72)$PAGEWIDTH  (136);Copyright (C) 1984, 1985 by Xerox Corporation. All rights reserved.;-- stored as [Idun]<WDLion>Dove>IOPInit.asm;-- created on  27-Feb-84 11:22:42;-- last edited by:;--	JAC	28-Jan-87 14:46:08	:use xCoordOffsetInit15 and yCoordOffsetInit15 from IOPData not hardwired numbers;--	JAC	30-Jan-87 16:31:33	:SystemStack is no longer in OpieSTK segment;--	JAC	28-Jan-87 14:46:08	:use xCoordOffsetInit19 and yCoordOffsetInit19 from IOPData not hardwired numbers;--	kek	17-Jul-86 10:12:15	:only count achips via reading the eep.;--	kek	24-Jun-86 15:24:19	:fix ASID/IORmap initing for multichip.;--	KEK	17-Apr-86  8:09:39	:add InitMapping for Daisy;--	JPM	16-Sep-85 17:06:03	:Fix bug at OpieReentryPoint (don't preserve boot area contents if doing a reboot).;--	JAC/KEK	11-Sep-85 15:11:43	:initialize newly defined timeoutEnable.;--	JPM	 8-Aug-85 13:34:00	:Fix bug in InitICB (trouble proc segment comes from CS).;--	JPM	 2-Aug-85 15:28:30	:Initialize eePromVersion array.;--	JPM	22-Jul-85 10:03:41	:Change IOPEInROM alignment to WORD.;--	JPM	19-Jul-85 13:36:45	:Assume Preboot enables system memory, but clear LED digits.;--	JPM	11-Jul-85 11:22:44	:Added EtherInitialize to list of init procs.;--	JPM	 9-Jul-85  8:35:25	:Fixed bug in InitICB (chain context, not ICB).;--	JPM	 8-Jul-85 11:54:28	:Added resetAllDevices (can't reset umbilical if Burdock in ROM), fixed bug in InitDone.;--	JPM	27-Jun-85 13:51:35	:Change InterruptsConfiguration to software interrupt routine (for RAM-based init), misc bug fixes.;--	JPM	26-Jun-85 11:51:51	:Put some routines into procs for RAM-based init to call.;--	JPM	25-Jun-85 13:13:35	:Opie redesign.;--	KEK	 5-Jun-85  9:23:49	:program master 8259 to be in ISR mode.;--	JPM	22-May-85  9:10:04	:Add OpieReentryPoint.;--	KEK	25-Apr-85 16:12:42	:moved temp 8274 defs into HardDefs. add 8259OptionsSlave init code (from PBOpie).  Make InterruptsConfiguration PUBLIC.  Add turning on of BlockSysMem.;--	KEK	16-Mar-85 18:07:13	:changed printing directives. Reset 8274. Always INCLUDE IOPMacro.;--	KEK	27-Feb-85 16:18:06	:add 8274 init code;add opieReentry vars.;--	KEK	26-Feb-85 21:09:21	:add latch-clears to i8259Init.;--	VXS	 5-Dec-84 17:12:57	:Make Initialization label PUBLIC for Bindweed so knows where to start the system.;--	VXS	29-Nov-84 16:45:15	:Fix problem with order of INCLUDE files.;						: Also put a null reference to IOPEInRAM (see comment there);--	VXS	21-Nov-84  0:29:29	:Add INCLUDEs of OpieDefs and HardOpie;--	VXS	16-Nov-84 11:49:55	:Adjust our idea of where first Daybreak main memory address is;--	VXS	15-Nov-84 11:54:55	:Add commented out instruction to init ControlRegData.;--	VXS	14-Nov-84 13:22:49	:Change init of system queue.;--	VXS	 8-Nov-84 15:40:21	:Add code to setup startOfBootBufferSpace and endOfBootBufferSpace.;--	VXS	 6-Nov-84 14:11:41	:make InitializeROMFunctions external - moved to HandInit.;--	VXS	10-Oct-84 19:07:14	:add maintPanelinit entry;--	VXS	28-Aug-84 18:54:34	:Add call to RS232CInit for subinterrupt testing.;--	VXS	28-Aug-84 11:48:49	:Change name of Bermuda flag to UmbilicalHandlerLoaded;--	VXS	28-Aug-84 11:36:08	:Removed temp defs for umbilical*IntrptVctType, they get defined in IOPDefs now;--	VXS	27-Aug-84 14:15:25	:Took out enable of UmbilicalSendInterrupt in case of Bermuda flag being 0;--	VXS	23-Aug-84 15:52:55	:Change size to end for LRam and IOR free stuff;--	VXS	23-Aug-84 15:02:18	:Added Bermuda flag (In code segment), which is set if bermuda is loaded.;--	VXS	14-Aug-84 19:27:11	:Add per task stacks;--	VXS	 9-Aug-84 17:33:30	:Had to include IOPMacro if ROMBurdock is set (ugh). Only Temporary.;--	VXS	 9-Aug-84 16:19:00	:Put in ROMBurdock assembly switch, do enables on umbilical ICBs.;--	VXS	 8-Aug-84 17:15:55	:Include IORegion so can use ASSUME;--	VXS	 8-Aug-84 15:35:16	:Put in include of IOPLRam.asm;--	VXS	 8-Aug-84 13:54:17	:no more beginSoftwareIntrptBase, use SoftwareInterruptBase instead;--	VXS	 7-Aug-84 19:31:59	:Added temporary code to not initialize the umbilical interrupt vectors;--	VXS	 6-Aug-84 17:21:57	:Change VctBase to VctType;--	VXS	 3-Aug-84 19:50:08	:Take HardDefs include back out;--	VXS	 3-Aug-84 19:34:10	:Add include of HardDefs.asm;--	VXS	 3-Aug-84 19:24:44	:Use macro IntrptType instead of symbols;--	JPM 	20-Jul-84 12:37:11	:Added WorkNotifierInit;--	VXS	17-Jul-84 18:56:31	:Fixed bug in IORegion clearing, was using byte;								 count to drive word clearing loop.;--	VXS	16-Jul-84 15:53:25	:Added EXTRN which used to be in IOImport;								 IOImport module disappears;--	JMM	27-Jun-84 15:14:43	:Opie Version 1 release;--	ETN	26-Jun-84 20:48:23	:changed init so tasks not needed;--	JMM	20-Jun-84 10:48:04NAME			IOPInit;--------------------------------------------------------------------------------%SET(ROMBurdock,1)			;Turn on trusting Burdock in ROM (turn off when get it in Opieland)$INCLUDE		(IOPDefs.asm)$INCLUDE		(OpieDefs.asm)$INCLUDE		(HardOpie.asm)$INCLUDE		(IOPMacro.asm)$INCLUDE		(ROMEEP.asm);(ROMEEP for eePromDispType/eePromHighMem equ's)%IF(%ROMBurdock) THEN (resetAllDevices		EQU	resetUmbilicalController	;don't reset umbilical) ELSE (resetAllDevices		EQU	0)FI$GENONLYEXTRN			SystemHandlerID: ABS;--------------------------------------------------------------------------------IOPELocalRAM		SEGMENT	AT 0EXTRN			opieReentry: SegmentAndOffsetEXTRN			skipUserInterface: BYTEEXTRN			timeoutEnable: BYTEEXTRN			aChipCount: BYTEEXTRN			machineCritter: BYTEEXTRN			i8259MasterIntrptVctBase: SegmentAndOffsetEXTRN			HandlerInitProcTable: SegmentAndOffsetEXTRN			opieIntrptVctBase: SegmentAndOffsetEXTRN			softwareIntrptVctBase: SegmentAndOffsetEXTRN			controlRegData: WORD, resetRegData: WORDEXTRN			eePromVersion: WORDEXTRN			IORSegmentTableAddress: SegmentAndOffsetEXTRN			IOROpieSegmentAddress: WORDEXTRN			firstAvailableLocalRAM: WORDEXTRN			startOfBootBufferSpace: WORD, endOfBootBufferSpace: WORDEXTRN			IOPELocalRamStart: WORDdisplayIntrptVct	EQU	IOPELocalRamStart+4*displayInterrupt%IF(%ROMBurdock) THEN (umbilicalRecIntrptVct	EQU	IOPELocalRamStart+4*umbilicalRecInterruptumbilicalSendIntrptVct	EQU	IOPELocalRamStart+4*umbilicalSendInterrupt) FI %' end if ROMBurdockIOPELocalRAM		ENDS;--------------------------------------------------------------------------------IORegion		SEGMENT	COMMONEXTRN			segmentTable: SegmentEntryIORegion		ENDS;--------------------------------------------------------------------------------OpieIOR			SEGMENT	COMMONEXTRN			SegmentTableAddress: SegmentAndOffsetEXTRN			CBbaseLocation: WORD, ICBbaseLocation: WORDEXTRN			i8259MasterController: ControllerBlockEXTRN			i8259SlaveController: ControllerBlockEXTRN			currentTaskTCBPtr: WORDEXTRN			systemQueue: IOPEQueueEXTRN			timerQueue: IOPEQueueEXTRN			watchDogQueue: WORDEXTRN			workNotifierBitsPtr: WORD, workNotifierBits: WORDEXTRN			workMaskLimit: BYTEEXTRN			ROMworkMaskLimit: ABSEXTRN			timerTask: TaskContextBlockEXTRN			watchDogTask: TaskContextBlockEXTRN			workNotifierTask: TaskContextBlock%IF(%ROMBurdock) THEN (EXTRN			umbilicalRecICB :interruptContextBlock) FI %' end if ROMBurdockOpieIOR			ENDS;--------------------------------------------------------------------------------OpieSTK			SEGMENT	COMMONEXTRN			IOPEStack: WORD, IOPTimerStack: WORDEXTRN			WatchDogStack: WORD, WorkNtfrStack: WORDOpieSTK			ENDSSystemSTK		SEGMENT		COMMONEXTRN			SystemStack: WORDSystemSTK		ENDS;--------------------------------------------------------------------------------DisplayIOR		SEGMENT	COMMONEXTRN  cursorXCoord :WORDEXTRN  cursorYCoord :WORDEXTRN  borderLow :BYTEEXTRN  borderHigh :BYTEEXTRN  cursorPattern :BYTEEXTRN  displCntl :BYTEEXTRN  mixRule :BYTEEXTRN  numberBitsPerLine :WORDEXTRN  numberDisplayLines :WORDEXTRN  configInfo :BYTEEXTRN  colorParams: WORDEXTRN  xCoordOffset :WORDEXTRN  yCoordOffset :WORDEXTRN  pixels :BYTEEXTRN  refresh :BYTEEXTRN  bitMapOrg :WORDEXTRN  numberQuadWords :WORDDisplayIOR		ENDS;********************************************************************************IOPEInROM		SEGMENT	WORD PUBLIC			ASSUME	CS:IOPEInROM; EXTRNs from IOPDataEXTRN			beginCBTable: WORD, wordsInCBTable: ABSEXTRN			beginICTable: WORD, numberOfICsForROMFunctions: ABS, sizeOfICInROM: ABSEXTRN			beginHardwareIVTable: WORD, numberOfHardwareIVsForROMFunctions: ABSEXTRN			beginSoftwareIVTable: WORD, numberOfSoftwareIVsForROMFunctions: ABSEXTRN			codeToInsertIntoICB: BYTEEXTRN			AChip15InchDisplayControllerData:WORD, number15InchParameters: ABSEXTRN			AChip19InchDisplayControllerData:WORD, number19InchParameters: ABSEXTRN			AChip256MemoryControllerData:WORD, number256MemoryParameters: ABSEXTRN			xCoordOffsetInit19:ABS, yCoordOffsetInit19:ABSEXTRN			xCoordOffsetInit15:ABS, yCoordOffsetInit15:ABSEXTRN			Debug64: AChipBlock, MemMap10: AChipBlock; EXTRNs from HandInitEXTRN			InitializeROMFunctions: NEAR%IF(%ROMBurdock) THEN (EXTRN			UmbilicalHandlerLoaded :BYTE)FI; EXTRNs from IOPKernlEXTRN			SystemLoop: NEAREXTRN			Unserviced: NEAREXTRN			ReadMasterISR: NEAR, ReadSlaveISR: NEAREXTRN			ReadEEProm: NEAREXTRN			IOPE@ReadEEProm: NEAR; EXTRNs from Opie tasksEXTRN			TimerTaskInit: NEAREXTRN			WatchDogTaskInit: NEAREXTRN			WorkNotifierTaskInit: NEAR; EXTRNs from bootingEXTRN			EtherInitialize: NEAR;--------------------------------------------------------------------------------;-- Memory and Chip initialization:;--------------  At this stage the machine is pristine and this is the very;--------------  first chance to . . .;--------------;--------------|								|;--------------|								|;--------------|								|;--------------|								|;--------------|								|;--------------|--------							|;--------------| 								|;--------------|								|;--------------|								|;--------------|								|;--------------|								|;--------------|								|;--------------|								|;--------------|								|;-------------------------------------------------------------------------------PUBLIC InitializationPUBLIC InitIOPPUBLIC InterruptsConfigurationPUBLIC DisplayInitializeInitialization:			InitializeMemory:			CLI			;Absolutely no interrupts allowed.SetUpDSforIntrptVcts:	MOV	DX, IOPELocalRAM			MOV	DS, DX		;to load interrupt vectors.			ASSUME	DS:IOPELocalRAM			; Set up restart variables for Diagnostics to use when restarting Opie.			MOV	opieReentry.segmentValue, CS			MOV	opieReentry.offsetValue, OFFSET OpieReentryPoint			MOV	skipUserInterface, 0			MOV	timeoutEnable, 1			JMP	SHORT DontPreserveBootArea; come here when restarting Opie to load overlay or rebootOpieReentryPoint:			CLI			MOV	DX, IOPELocalRAM			MOV	DS, DX			CMP	skipUserInterface, 0	;if overlay,			JNE	SetUpInterruptMode	; preserve boot area contents; set up zero-length boot area (bootstrap will adjust)DontPreserveBootArea:	MOV	startOfBootBufferSpace, LowRamSize	;end of local RAM			MOV	endOfBootBufferSpace, LowRamSize	;end of local RAM; Setup internal interrupt controller mode bitsSetUpInterruptMode:	MOV	DX, i186RelocationRegAddr	;Using iRMX mode			MOV	AX, i186RelocationRegvalue			OUT	DX, AX; put all devices into reset state			MOV	AX, resetAllDevices			OUT	WriteResetReg, AX; set up stack segment and init pointer			MOV	AX, OpieSTK			MOV	SS, AX			MOV	SP, OFFSET IOPEStack;-- Interrupt Vectors initialization:;--------------  Assume no parameters upon entry into InterruptVector;--------------  Initialization.;--------------;--------------|								|;--------------|--------							|;--------------| Upon exiting this procedure the following will be true:	|;--------------|								|;--------------|								|;--------------|		All interrupt vectors should be o.k.	 	|;--------------|								|;--------------|								|;--------------|								|;-------------------------------------------------------------------------------InterruptVectorInitialization:;First fill the vector table with no-ops.			MOV	DI, OFFSET i8259MasterIntrptVctBase			MOV	AX, OFFSET Unserviced			MOV	CX, (128-i8259MasterIntrptVctType)FillIntrptVctNoOps:%IF(%ROMBurdock) THEN (			CMP	DI, OFFSET umbilicalRecIntrptVct			JE	NoVectorNoOp		;if its umbilical, don't wipe out vectors for now			CMP	DI, OFFSET umbilicalSendIntrptVct			JE	NoVectorNoOp) FI %' end if ROMBurdock			MOV	[DI].offsetValue, AX			MOV	[DI].segmentValue, CSNoVectorNoOp:		ADD	DI, SIZE SegmentAndOffset			LOOP	FillIntrptVctNoOps 	;Loop until done			MOV	DI, OFFSET HandlerInitProcTable			MOV	AX, OFFSET NullProc			MOV	CX, 128FillHandlerInitNoOps:	MOV	[DI].offsetValue, AX			MOV	[DI].segmentValue, CS			ADD	DI, SIZE SegmentAndOffset			LOOP	FillHandlerInitNoOps 	;Loop until done;now load hardware and software vectors from data tablesHardwareVectors:	MOV	SI, OFFSET beginHardwareIVTable			MOV	BX, OpieIOR			MOV	CX, numberOfHardwareIVsForROMFunctionsInitializeHardwareVectors:			MOV	DI, CS:[SI]%IF(%ROMBurdock) THEN (			TEST	CS:UmbilicalHandlerLoaded, 1	;see if UmbilicalHandler is loaded			JNE	UmbilicalHandlerIsLoaded			CMP	DI, OFFSET umbilicalRecIntrptVct			JE	NoVectorInit		;if its umbilical, don't wipe out vectors for now			CMP	DI, OFFSET umbilicalSendIntrptVct			JE	NoVectorInitUmbilicalHandlerIsLoaded:) FI %' end if ROMBurdock			MOV	AX, CS:[SI]+2			MOV	[DI].offsetValue, AX			MOV	[DI].segmentValue, BXNoVectorInit:		ADD	SI, 4			LOOP	InitializeHardwareVectors ;Loop until doneOpieInitVectors:	MOV	SI, OFFSET beginOpieIVTable			MOV	DI, OFFSET opieIntrptVctBase			MOV	CX, numberOfOpieIVsForROMFunctionsInitializeOpieInitVectors:			MOV	AX, CS:[SI]			MOV	[DI].offsetValue, AX			MOV	[DI].segmentValue, CS			ADD	SI, 2			ADD	DI, 4			LOOP	InitializeOpieInitVectors ;Loop until doneSoftwareVectors:	MOV	SI, OFFSET beginSoftwareIVTable			MOV	DI, OFFSET softwareIntrptVctBase			MOV	CX, numberOfSoftwareIVsForROMFunctionsInitializeSoftwareVectors:			MOV	AX, CS:[SI]			MOV	[DI].offsetValue, AX			MOV	[DI].segmentValue, CS			ADD	SI, 2			ADD	DI, 4			LOOP	InitializeSoftwareVectors ;Loop until done			MOV	HandlerInitProcTable[opieHandlerID].offsetValue, OFFSET OpieInit;-- Opie structures initialization:;-------------- ICB's and IOR's and LRAM AND THE ACHIP+InterruptControllers!...;--------------;--------------;--------------|								|;--------------|--------							|;--------------| Upon exiting this procedure the following will be true:	|;--------------|								|;--------------|								|;--------------|							 	|;--------------|								|;--------------|								|;--------------|								|;-------------------------------------------------------------------------------FinishIOPELocalRAMInit:			MOV	controlRegData, CRNotBlockSysMem	;set by Preboot			MOV	resetRegData, resetAllDevices			MOV	IORSegmentTableAddress.segmentValue, IORegion			MOV	IORSegmentTableAddress.offsetValue, OFFSET segmentTable			MOV	IOROpieSegmentAddress, BX			XOR	BX, BX			XOR	DI, DI			MOV	CX, 3InitEEPromVersions:	CALL	ReadEEProm			MOV	eePromVersion[DI], AX			INC	BX			ADD	DI, 2			LOOP	InitEEPromVersions; now zero out all the rest of local RAM (except boot area, in case of overlay request)ZeroRestOfLocalRAM:			MOV	AX, DS			MOV	ES, AX		; for string store			XOR	AX, AX			CLD			; enable auto-increment			MOV	CX, startOfBootBufferSpace			MOV	DI, OFFSET firstAvailableLocalRam			SUB	CX, DI			JCXZ	SkipBootArea			SHR	CX, 1		; change to word count			REP	STOSWSkipBootArea:		MOV	CX, LowRamSize			MOV	DI, endOfBootBufferSpace			SUB	CX, DI			JCXZ	ConfigureIOP			SHR	CX, 1		; change to word count			REP	STOSW					; program interrupt controllers; program memory controller; program display controller; (just in case diagnostics smashed preboot's programming).ConfigureIOP:		CALL	InitIOP; now get Opie's IOR initializedInitializeOpieIOR:	LES	BX, IORSegmentTableAddress			MOV	DS, IOROpieSegmentAddress			ASSUME	DS:OpieIOR			MOV	ES:[BX].ioRegionSegment, DS			MOV	ES:[BX].stackSegment, SS			MOV	SegmentTableAddress.segmentValue, ES			MOV	SegmentTableAddress.offsetValue, BX			%CallIRETproc	(InitStdOpieIOR)			MOV	workNotifierBitsPtr, OFFSET workNotifierBits			MOV	workMaskLimit, LOW ROMworkMaskLimit			CALL	FAR PTR OpieInit; Now call routine in HandInit to start up the ROM based handlers.			CALL	InitializeROMFunctions; at this point assume only that SS contains Opie's stack segment;since SystemStack is no longer in Opie's regular stack segment must also change SSInitDone:		%LoadOpieSegment	(ES,AX)			MOV	SI, SystemHandlerID			SHL	SI, 2			MOV	SS, [BX + SI].stackSegment			MOV	SP, OFFSET SystemStack			JMP	SystemLoop			ASSUME	DS:NOTHING;-------------------------------------------------------------------------------; private Opie initialization routines (to be used by RAM-based Opie)beginOpieIVTable:			DW	OFFSET InterruptsConfiguration			DW	OFFSET InitStdOpieIOR			DW	OFFSET InitICB			DW	OFFSET InitDone			DW	OFFSET EtherInitializeendOpieIVTable:sizeOfOpieIVTable	EQU	(endOpieIVTable-beginOpieIVTable)numberOfOpieIVsForROMFunctions	EQU	sizeOfOpieIVTable/2;-------------------------------------------------------------------------------InterruptsConfiguration:ClearIntrLatchPorts:	IN	AX, ClrRingLatch			IN	AX, ClrMesaIntr			IN	AX, ClrENetIntr			IN	AX, ClrRetraceIntr			MOV	DX, i186EOIRegAddr			MOV	AX, i186IntrChannelForTimer2			OUT	DX, AXClearLEDDigits:		XOR	AX, AX			OUT	WriteLED, AXi8259Initialization:;	This section is used to setup interrupt controller #1SetUpMasteri8259:			MOV	AL, i8259MasterICW1	;Set up the 8259 operation			OUT	i8259MasterAddr0, Al	;by writing ICW1 to control reg 0			MOV	AL, i8259MasterIntrptVctType ;and ICW2-4 to control reg 1			OUT	i8259MasterAddr1, Al			MOV	AL, i8259MasterICW3			OUT	i8259MasterAddr1, Al			MOV	AL, i8259MasterICW4			OUT	i8259MasterAddr1, Al			MOV	AL, i8259AllInhibited	;All interrupts are inhibited			OUT	i8259MasterIntrptMaskPort, Al	;until we turn them on later;Now, we must give the read register command to the master 8259 so that the; ISR (in-service register) bits are available			MOV	AL, i8259ISRread	;read ISR on subsequent reads			MOV	DX, i8259MasterAddr0			OUT	DX, AL;----------------------SetUpSlavei8259:			MOV	AL, i8259SlaveICW1	;Set up the 8259 operation			OUT	i8259SlaveAddr0, Al	;by writing ICW1 to control reg 0			MOV	AL, i8259SlaveIntrptVctType	;and ICW2-4 to control reg 1			OUT	i8259SlaveAddr1, Al			MOV	AL, i8259SlaveICW3			OUT	i8259SlaveAddr1, Al			MOV	AL, i8259SlaveICW4			OUT	i8259SlaveAddr1, Al			MOV	AL, i8259AllInhibited ;All interrupts are inhibited			OUT	i8259SlaveIntrptMaskPort, Al	;until we turn them on later;Now, we must give the read register command to the slave 8259 so that the; ISR (in-service register) bits are available			MOV	AL, i8259ISRread	;read ISR on subsequent reads			MOV	DX, i8259SlaveAddr0			OUT	DX, AL;----------------------SetUpSlavei186:			MOV	AX, i80186SlaveIntrptVctType ;initialize interrupt vector			MOV	DX, i186IntVectorRegAddr     ;register			OUT	DX, AX;Program priorities of internal 186 interrupts			MOV	DX, i186Timer0IntCtlAddr			MOV	AL, i186IntrChannelforTimer0			OUT	DX, AL			MOV	DX, i186DMA0IntCtlAddr			MOV	AL, i186IntrChannelforDMA0			OUT	DX, AL			MOV	DX, i186DMA1IntCtlAddr			MOV	AL, i186IntrChannelforDMA1			OUT	DX, AL			MOV	DX, i186Timer1IntCtlAddr			MOV	AL, i186IntrChannelforTimer1			OUT	DX, AL			MOV	DX, i186Timer2IntCtlAddr			MOV	AL, i186IntrChannelforTimer2			OUT	DX, AL;Now make sure internal interrupt controller channels are initially masked off.			MOV	DX,i186IntrMaskRegAddr			MOV	AL, i80186AllInhibited			OUT	DX, AL;Policy of Interrupts is to have each individual handler enable its own interrupt.; However, Opie is responsible for initially enabling the 8259 channels which have; slave interrupt controllers on them (either 8259 or internal 186).EnableCPUInterrupts:	MOV	AL, i80186SlaveIntrptOn%IF(%ROMBurdock) THEN (;While Burdock lives in ROM, must enable its receive channel.			TEST	CS:UmbilicalHandlerLoaded, 1		;see if UmbilicalHandler is loaded			JNZ	DontEnableUmbilical			AND	AL, umbilicalRecEnableDontEnableUmbilical:) FI %' end if ROMBurdock			OUT	i8259MasterIntrptMaskPort, AL		        IRET			;-------------------------------------------------------------------------------;initialize display and memory controller for DaisyInitIOP:		MOV	AX, IOPELocalRAM			MOV	DS, AX			ASSUME DS:IOPELocalRAM			;IN	AL, machineIDPort	;init machineCritter			;AND	AL, machineIDMask			;MOV	DS:machineCritter, AL			%CallIRETproc	(InterruptsConfiguration)			CALL	MemoryInitialize			CALL	DisplayInitializeInitIOPDone:		RET;memory controller init codeMemoryInitialize:	;CMP	DS:machineCritter, Daisy			;JNE	DaybreakMemoryInitDaisyMemoryInit:	;program memory registers for all A-chips;All 4 potential AChips' memory controller registers are programmed identically.; All map registers are left disabled, ASID's uninitialized, chipSwitch � 256K.			MOV	DS:aChipCount, 1	;assume one actual chip..			XOR	CH, CH			MOV	CL, maxChipCount	;but init all possible			MOV	DX, 0700HAChipLoop:		PUSH	CX			INC	DH			MOV	SI, OFFSET AChip256MemoryControllerData			MOV	CX, number256MemoryParametersMemoryRegisterLoop:	MOV	DL, CS:[SI]			MOV	AX, CS:[SI]+1			OUT	DX, AX			ADD	SI, 3			LOOP	MemoryRegisterLoop			POP	CX			LOOP	AChipLoop;The above loop didn't init the ASID of the AChips.  This register must be; unique for ea chip.  Here it is written to be equal to the chip's AID.  This; will enable a one-chip system.  If the system is multichip, then then ASID's; of the first two chips will be xchg'd to comply with SChip's requirements.; (the reassignment of multichipASID's is done in DaisyVM)			MOV	DX, 0B2EH	;ASID port			MOV	AX, 3ASIDRegisterLoop:	OUT	DX, AX			DEC	DH			DEC	AX			JNZ	ASIDRegisterLoop			OUT	DX, AX	;out the zeroth ASID.;The DRAM-type code is commented out cuz no development machine has 64KDRAMs.;Determine DRAM type for AChip0 by writing to first 2 bytes of mem via MemMap1.; note chip0 has already been programmed for 256KDRAMs.			;MOV	DX, daisyMapIOAddressIOPBase+1			;MOV	AL, 08H			;OUT	DX, AL		;use memmap1 to map to memory.			;PUSH	ES		;use ES to point to map.			;ASSUME	ES:NOTHING			;MOV	AX, 0200H			;MOV	ES, AX			;MOV	ES:WORD PTR 0, 0ABCDH			;MOV	ES:WORD PTR 2, 01234H			;MOV	BX, ES:WORD PTR 0			;POP	ES			;ASSUME	ES:IOPELocalRam			;MOV	DX, daisyMapIOAddressIOPBase+1	;clear memmap1.			;MOV	AL, 00H			;OUT	DX, AL			;CMP	BX, 01234H		;test truth of 256'ness			;JNE	MemoryInitializeDone			;MOV	DH, 08H			;MOV	DL, Debug64.port 	;it's really 64KDRAMs			;MOV	AX, Debug64.data			;OUT	DX, AX;This is prototype code to determine AChip presence, by reading the EEPROM.; The number of AChips must be determined at this time cuz the IOR map register; -- where debugging code is loaded -- goes in the second AChip if it is present,; else the first.  This is determined via the EEPROM cuz its nice to change debug; configurations just by writing the EEPROM instead of touching the hardware.; If the EEPROM is bad, then the presence of the second AChip is determined by; seeing if the values it was programmed with actually took.;Note the assumption here, that if the second chip is present than there is; at least a half meg of memory behind it.			;read the EEPROM.			MOV	BX, eePromHighMem			MOV	AX, 1;(version)			%CallIRETproc	(IOPE@ReadEEProm)			;JNC	UseEEPValue;(the case of the bad eeprom is commented out becuz this code is called by; preboot before the cache'd eePromVersion data is initialized.)UseActualChipValue:	;MOV	DX, 0900H	;look at RAMSize, for example.			;IN	AX, DX			;CMP	AX, 0C000H	;RAMSize data			;JZ	MultiChipIOR			;JMP	SingleChipIORUseEEPValue:		AND	AX, 00FFH			JNZ	MultiChipIORSingleChipIOR:		;program chip0 map to point to IOR			MOV	DX, 0804H			MOV	AX, 0009H			OUT	DX, AX			JMP	SHORT MemoryInitializeDoneMultiChipIOR:		;program chip1 map to point to IOR			MOV	DX, 0904H			MOV	AX, 0009H			OUT	DX, AX			;JMP	MemoryInitializeDoneDaybreakMemoryInit:	;MOV	DS:aChipCount, 0			;MOV	DX, daybreakMapIOAddressIOPBase			;MOV	AL, 05H			;OUT	DX, ALMemoryInitializeDone:	RET;(and that IO map reg is programed as told by detecting actual AChip presence);(and that all four chips are running (MInit is inactive));display controller init code (also inits Display IOR);note that on exit the cursor is invisible and border covers screen.;Booting must do mixRule�0EH; displCntl�0E4H; & VCursor(ch0)�80C7H; to make cursor visible.  And must do HBorder1(ch0{15/19})�{603EH/605CH}; to make border only cover edges.DisplayInitialize:	PUSHA			PUSH	ES			PUSH	DS			MOV	AX, DisplayIOR			MOV	ES, AX			ASSUME	ES:DisplayIOR			MOV	AX, IOPELocalRAM			MOV	DS, AX			ASSUME	DS:IOPELocalRAM			;init display IOR data			MOV	ES:bitMapOrg, 0			MOV	ES:colorParams, 0			MOV	ES:cursorXCoord, 0			MOV	ES:cursorYCoord, 0			MOV	ES:borderLow, 0BBH			MOV	ES:borderHigh, 0EEH			MOV	ES:displCntl, 004H			MOV	ES:mixRule, 00H			MOV	ES:pixels, 80			MOV	ES:refresh, 38			MOV	ES:numberDisplayLines, 633;assume 15"			MOV	ES:numberBitsPerLine, 832;assume 15"			MOV	ES:numberQuadWords, 13	;assume 15"			;CMP	DS:machineCritter, Daisy			;JNE	DaybreakDisplayInitDaisyDisplayInit:	MOV	ES:configInfo, 80H			MOV	ES:xCoordOffset, xCoordOffsetInit15 ;16*lowByte of HBorder015			MOV	ES:yCoordOffset, yCoordOffsetInit15 ;lowBtye of VBorder015			;init A-chip display controller as 15"er.			MOV	SI, OFFSET AChip15InchDisplayControllerData			MOV	DH, 08H			MOV	CX, number15InchParametersDaisy15InchLoop:	MOV	DL, CS:[SI]			MOV	AX, CS:[SI]+1			OUT	DX, AX			ADD	SI, 3			LOOP	Daisy15InchLoop			;reset chip1/2/3 display.			MOV	DX, 09A4H	;HBorder1 for no display			MOV	AX, 0F000H			OUT	DX, AX			INC	DH;=0AA4H			OUT	DX, AX			INC	DH;=0BA4H			OUT	DX, AX			;reset chip0 display if not present.			MOV	BX, eePromDispType			MOV	AX, 1;(version)			%CallIRETproc	(IOPE@ReadEEProm)			JC	DaisyConfirm15Inchness	;bad default => present.			AND	AX, 01H			CMP	AX, 0			JNZ	DaisyConfirm15Inchness	turnOffDisp:	MOV	DX, 08A4H			MOV	AX, 0F000H	;disable display (not present).			OUT	DX, AX			JMP	DisplayInitializeDoneDaisyConfirm15Inchness:	;compute display type			IN	AL, DaisyDisplayTypePort			AND	AL, DaisyDisplayTypeMask			CMP	AL, DaisyfifteenInch			JE	DisplayInitializeDoneDaisyReconfigTo19Inch:	OR	ES:configInfo, 20H			;init A-chip display controller as 19"er.			MOV	ES:numberDisplayLines, 861;assume 19"			MOV	ES:numberBitsPerLine, 1152;assume 19"			MOV	ES:numberQuadWords, 18	;assume 19"			MOV	ES:xCoordOffset, xCoordOffsetInit19 ;16*lowByte of Hborder019			MOV	ES:yCoordOffset, yCoordOffsetInit19 ;lowByte of VBorder019			MOV	SI, OFFSET AChip19InchDisplayControllerData			MOV	DH, 08H			MOV	CX, number19InchParametersDaisy19InchLoop:	MOV	DL, CS:[SI]			MOV	AX, CS:[SI]+1			OUT	DX, AX			ADD	SI, 3			LOOP	Daisy19InchLoop			;JMP	DisplayInitializeDoneDaybreakDisplayInit:	;MOV	ES:configInfo, 0			;init daybreak 15" display			;MOV	ES:xCoordOffset, 208			;MOV	ES:yCoordOffset, 32DaybreakConfirm15Inchness:;compute display type			;MOV	DX, DisplayTypePort			;IN	AX, DX			;TEST	AL, DisplayTypeMask			;JZ	DaybreakReconfigTo19Inch			;JMP	DisplayInitializeDoneDaybreakReconfigTo19Inch:;init daybreak 19" display			;OR	ES:configInfo, 20H			;MOV	ES:numberDisplayLines, 861;assume 19"			;MOV	ES:numberBitsPerLine, 1152;assume 19"			;MOV	ES:numberQuadWords, 18	;assume 19"			;MOV	ES:xCoordOffset, 304	;assume 19"DisplayInitializeDone:	POP	DS			POP	ES			POPA			RET;(note border remains covering entire screen & cursor is uninited and invisible.);-------------------------------------------------------------------------------InitStdOpieIOR:; DS points to Opie's IORegion segment			ASSUME	DS:OpieIOR; initialize CBs			MOV	SI, OFFSET beginCBTable			MOV	DI, OFFSET CBbaseLocation			MOV	CX, wordsInCBTable			MOV	AX, DS			MOV	ES, AX	;for string movesCBTableLoop:	REP	MOVS	WORD PTR ES:[DI], CS:[SI]; initialize ICBs			MOV	SI, OFFSET beginICTable			MOV	DI, OFFSET ICBbaseLocation			MOV	CX, numberOfICsForROMFunctions			MOV	AX, CS			MOV	ES, AX	;for init callsICTableLoop:		%CallIRETproc	(InitICB)			ADD	DI, SIZE interruptContextBlock			ADD	SI, sizeOfICInROM			LOOP	ICTableLoop; initialize queues			MOV	systemQueue.handlerIDforHead, nilHandlerID			MOV	systemQueue.handlerIDforTail, nilHandlerID			MOV	timerQueue.handlerIDforHead, nilHandlerID			MOV	timerQueue.handlerIDforTail, nilHandlerID			MOV	currentTaskTCBPtr, NullTCBPtr			IRET			ASSUME	DS:NOTHING;-------------------------------------------------------------------------------InitICB:; DS:[DI] points to ICB (in Opie's IOR)			ASSUME	DS:OpieIOR; ES:[SI] points to fixed data for interrupt context; CX preserved, other registers can be used; first copy in the code bytes			MOV	BX, 0InitICBCodeBytes:	MOV	AL, CS:codeToInsertIntoICB[BX]			MOV	[DI][BX], AL			INC	BX			CMP	BX, ICBcodeBytes			JL	InitICBCodeBytes; now copy fixed data to IC			MOV	BX, 0			ADD	DI, ICBcodeBytes+variableSizeOfICInitICBFixedData:	MOV	AL, ES:[SI][BX]			MOV	[DI][BX], AL			INC	BX			CMP	BX, sizeOfICInROM			JL	InitICBFixedData			SUB	DI, ICBcodeBytes+variableSizeOfIC; check for special cases (IR7 of master or slave 8259)			CMP	[DI].ICBcontext.interruptMask, i8259EnableIR7			JNE	LinkToWatchDogQueue			CMP	[DI].ICBcontext.interruptController, OFFSET i8259MasterController			JNE	NotMasterController			MOV	WORD PTR [DI]+2, OFFSET ReadMasterISR			JMP	SHORT LinkToWatchDogQueueNotMasterController:	CMP	[DI].ICBcontext.interruptController, OFFSET i8259SlaveController			JNE	LinkToWatchDogQueue			MOV	WORD PTR [DI]+2, OFFSET ReadSlaveISR; finally, fill in non-zero defaults and link into watchdog queueLinkToWatchDogQueue:	ADD	DI, ICBcodeBytes			MOV	[DI].troubleIPCS.segmentValue, CS			MOV	[DI].troubleIPCS.offsetValue, OFFSET NullProc			MOV	AX, watchDogQueue			MOV	[DI].watchdogLinkPtr, AX			MOV	watchDogQueue, DI			SUB	DI, ICBcodeBytes			IRET			ASSUME	DS:NOTHING;-------------------------------------------------------------------------------OpieInit		PROC	FAR; start Opie's tasksInitializeOpieTasks:	%InitializeTask	(opieHandlerID,OFFSET timerTask,TimerTaskInit,OFFSET IOPTimerStack)			%InitializeTask (opieHandlerID,OFFSET watchDogTask,WatchDogTaskInit,OFFSET WatchDogStack)			%InitializeTask (opieHandlerID,OFFSET workNotifierTask,WorkNotifierTaskInit,OFFSET WorkNtfrStack)			RETOpieInit		ENDP;--------------------------------------------------------------------------------NullProc		PROC	FAR			RETNullProc		ENDP;--------------------------------------------------------------------------------IOPEInROM		ENDS;********************************************************************************			END