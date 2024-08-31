;Copyright (C) 1984, 1985 by Xerox Corporation. All rights reserved.;-- stored as [Idun]<WDLion>Dove>IOPDefs.asm;-- created on  14-Feb-84 11:13:22;-- This file contains public definitions which Opie exports to its clients.;-- Any hardware dependent defintions which Opie uses can be found in;-- hardOpie.asm, and Opie's private definitions are found in OpieDefs.asm.;;-- last edited by:;--	JPM	24-Jul-85 12:00:42	:Added extendedBusPageOpieAddress;--	JPM	26-Jun-85 15:40:03	:Removed Crash macro;--	JPM	24-Jun-85  9:11:00	:Change taskContextBlock again;--	JPM	20-Jun-85 10:25:05	:Change taskContextBlock;--	JPM	15-May-85 13:42:34	:Opie redesign;--	KEK	11-Mar-85 17:40:56	:fixed returnSPSS fatfinger;--	KEK	 2-Mar-85 19:07:37	:add returnSPSS, remove unexpaectedInterrupt and WatchDogTimeout.;--	VXS	27-Nov-84 11:48:31	:Change DW to DB SIZE QueueEntry in TCB definition.;--	VXS	20-Nov-84 22:15:55	:Move def of conditionTimeout to IOPMacro.asm;--	VXS	20-Nov-84 17:06:21	:Take out hardware dependent non-exported definitions and move them into HardOpie.asm;--	VXS	20-Nov-84 15:13:45	:change TCB structure item queue to taskQueue to avoid naming conflict.;--	VXS	15-Nov-84 11:53:21	:Add ControlRegData to IOPEFCB;--	VXS	14-Nov-84 12:59:30	:Introduce QueueEntry structure;--	VXS	 5-Nov-84 16:07:55	:Add map register memory image.;--	VXS	 1-Nov-84 13:19:02	:add conditionTimeout definition;--	VXS	17-Oct-84 16:34:14	:change floppy and options DMA channels to i186IntrChannelforDMA0 and i186IntrChannelforDMA1;					: instead of 1 and 2.  Also change to using i186IntrChannelforTimer2 for the IOPE timer.;--	VXS	16-Oct-84 19:26:32	:Add byte to TCB to make it an even number of words. ;--	VXS	12-Oct-84 18:19:09	:add new location to TCB so can restart a task. ;--	VXS	11-Oct-84 11:39:44	:Added mesa page map stuff to IOPE FCB ;--	VXS	11-Oct-84 10:10:30	:Remove Allow? macros ;--	VXS	 4-Oct-84 19:15:42	:Add OpieAddressLow to be consistent with OpieAddressHigh alias. ;--	VXS	 4-Oct-84 18:05:23	:Add AllowRDC and AllowPC macro definitions for SystemLoop ;--	VXS	 4-Oct-84 17:24:28	:Add map register assignments. ;--	VXS	 4-Oct-84 15:48:25	:Add TCB location generalMapData ;--	VXS	 3-Oct-84 16:58:18	:Moved FloppyTimer stuff to HardDefs since timer 1 is hardwired to floppy stuff.;--	VXS	 1-Oct-84 19:54:31	:Changed some "sizeof" variables to use SIZE of the structure rather than use number by hand;--	VXS	 1-Oct-84 19:04:27	:Added definitions to allocate timer 0 to the floppy disk handler;--					 Corrected Spelling of IOPETimeIntCntrlReg to IOPETimerIntCntrlReg;--	VXS	 1-Oct-84 16:13:19	:Remove client condition definition bit (8000);--	VXS	26-Sep-84 15:46:20	:Changed GENONLY listing stuff at Interruptcontrollers macro call;--	VXS	25-Sep-84 12:48:20	:Eliminate MesaLogicalByte from Opie Addresses;--	VXS	24-Sep-84 18:30:22	:Change GEN to GENONLY for better listings.;--	VXS	18-Sep-84 20:22:01	:Fix save,gen, restore stuff to be in first column;--	VXS	17-Sep-84 18:47:01	:Add symbols for interrupt trouble routine AX indicator values;--	VXS	17-Sep-84 17:04:20	:Add save,gen,restore around macro expansions to show symbol definitions;--	VXS	 6-Sep-84 14:26:26	:Add new Crash macro.;--	VXS	27-Aug-84 15:58:46	:Add i8259OptionsSlaveIntrptMaskPort symbol.;--	VXS	27-Aug-84 15:26:33	:Redefine Opie Addresses;--	VXS	23-Aug-84 15:53:58	:change sizeOf???Available in IOPEFCB to endOf;--	VXS	22-Aug-84 16:57:58	:Added i186LogicalOpieAddress (for ds:offset things);--	VXS	22-Aug-84 11:12:35	:Put in equates for Opie Addresses, Make IOPEFCB same size as TCBs are (why? find out later);--	VXS	14-Aug-84 12:32:57	:Change taskcontextblock for private stacks (take out entryipcs, put in taskSPSS);--	VXS	14-Aug-84 12:05:25	:Get rid of sizeofTCB;--	VXS	 7-Aug-84 13:58:01	:Change IntrptVctBase to IntrptVctType for correctness;--					: Also SoftwareInterruptBase _ Type;--	VXS	 3-Aug-84 13:20:26	:Take out hardware stuff, will now be found in HardDefs.asm;--	VXS	19-Jul-84 18:16:47	:Put in $GEN directive;--	VXS	12-Jul-84 16:35:09	:Moved Devices macro here so IOregion can use it;--	VXS	11-Jul-84 16:28:56	:Took out device specific symbol defs, put them into;					: seperate Definitions files.;--	JPM	11-Jul-84 11:24:39	:added EEProm indexes (first pass per PJT, 25-Jun-84);--	VXS	 9-Jul-84 18:23:32	:fixed erroneous definition of i8259EOINonSpecific;--	VXS	 5-Jul-84 16:14:29	:changed sizeofICB def to use SIZE;					:removed individual ICB symbol definitions, replaced;					: with Devices macro in IOPData.asm;					:Fixed error in EOI command port;--	JPM	 3-Jul-84 14:31:37	:added wordsInEEProm;--	FXB	29-Jun-84 16:18:18	:added Umbilical Handler constants;--	JMM	27-Jun-84 15:07:10	:Compatible with Opie Version 1 release.;--	VXS	24-Jun-84 14:36:36	:Changed i80186SlaveIntrptOn to include all;					 slave interrupt channels on the master;--	ETN	26-Jun-84 15:30:15	:TCB struc.;--	JMM	22-Jun-84  7:06:32	:Misc. fixes.;--	ETN	21-Jun-84 18:33:26	:Remove IORegion EQUs;--	JMM	19-Jun-84 22:05:24	:Misc. fixes.;--	JMM	17-Jun-84  6:39:19	:structure updates.;--	JMM	10-Jun-84 17:29:33	:Version 1 release.$NOGEN;---------------------------------------------------;; Constant EquatesLowNibbleMask	EQU	0FHHighNibbleMask	EQU	0F0HNull		EQU	0HNibble		EQU	4H;;--------------------------------------------------------------------------------;Opie DATA STRUCTURES:;;-----------------------;Condition		STRUCTCBLinkPtr		DW	?				Condition		ENDS;sizeOfCondition	EQU	SIZE ConditionnonNilPtr		EQU	8000H		;Since 0 is a valid offset, high bit in TCBLinkPtr						; signifies non-null ptrpreNotifyFlag		EQU	0001H		;If in the TCBLinkPtr for condition variable,						; means prenotify has happened.;-----------------------;ClientCondition	STRUC  handlerID		DB	?	;ID of clientconditionRelMaskPtr	DB	?	; = (maskPtr - conditionPtr)conditionPtr		DW	?	;in client's IORegion segmentclientMask		DW	?	;if 0, conditionRelMaskPtr ignored				ClientCondition	ENDS  sizeOfClientCondition	EQU	SIZE ClientCondition;-----------------------;					;Here are definitions for Opie Addresses.;An Opie address is a 32 bit quantity which is capable of describing the various; address spaces and variations on those address spaces encountered in the IOP.;The addresses are defined as a structure here for clarity, but it may be; more convenient in actual coding to just use the type equates, and not use; the structure offsets.;;Although this is not guaranteed for all future releases, the type field can; be thought of as being broken up into 3 fields:;	Bits 7-6	Logical Address Space Selector;	Bits 5-4	Format Determination (Nil, Byte, Word, Page);	Bits 3-0	Base Specification (dependent on Logical Address Space);;There are several types of nil Opie Address, but only one is really supported.;;See OpieAddresses.txt for further discussion of these types.;;mesaLogical is mesaVirtual with real memory guaranteed to be behind the involved pages.nilOpieAddress			EQU	0extendedBusOpieAddress		EQU	010HextendedBusPageOpieAddress	EQU	030HIOPLogicalOpieAddress		EQU	050HIOPIORegionOpieAddress		EQU	051HPCLogicalOpieAddress		EQU	090HmesaLogicalWordOpieAddress	EQU	0E0HmesaEnvBaseWord			EQU	0E1HmesaLogicalPageOpieAddress	EQU	0F0HOpieAddress		STRUCOpieAddressA15toA0	DW	?	;bits 15 to 0OpieAddressA23toA16	DB	?	;bits 23 to 16OpieAddressType		DB	?	;first byte is type, see equates aboveOpieAddress		ENDS;If OpieAddressType = IOPIORegionOpieAddressOpieAddressHandlerID	EQU	BYTE PTR OpieAddressA23toA16;For accessing the high word as a word (low provided for consistency):OpieAddressHigh		EQU	WORD PTR OpieAddressA23toA16OpieAddressLow		EQU	WORD PTR OpieAddressA15toA0;-----------------------;Map register assignments (machine independent)PCEMapRegisterBase	EQU	0	;base is zeroIORegionMapRegister	EQU	8+0		;Has lower 16k shadowed by EPROM.mesaVMMapRegister	EQU	8+1comRecMapRegister	EQU	8+2comSendMapRegister	EQU	8+3floppyDMAMapRegister	EQU	8+4optionDMAMapRegister	EQU	8+5generalMapRegister	EQU	8+6spareMapRegister	EQU	8+7		;Has upper 16K shadowed by EPROM.;;-----------------------;QueueEntry		STRUCIOPEQueueType		DB	?		;e.g. system, timernextHandlerID		DB	?		;ID of next task in queuenextTCBLinkPtr		DW	?		;offset of next taskQueueEntry		ENDS;-----------------------;taskContextBlock	STRUCtaskQueue		DB	(SIZE QueueEntry) DUP (?)taskCondition		DW	?	;if in waitForCondition statetaskICPtr		DW	?	;set by ThisTaskServicestaskSP			DW	?	;holds stack pointer while waitingreturnSPSS		DW	?	;holds return-from-int addresses			DW	?taskState		DB	?	;Bits 7-4 Previous state, Bits 3-0 Present state.taskHandlerID		DB	?	;set by InitializeTasktimerValue		DW	?	;counted down by timertaskContextBlock	ENDS;-----------------------;ICBcodeBytes		EQU	6	;PUSHA, CALL FAR GenericInterruptProcessinginterruptContext	STRUC		;do not alter the order of the fields!interruptStatus		DB	?	;task waiting, active, timed out, ...interruptHandlerID	DB	?	;for task servicing this interruptinterruptTCBLinkPtr	DW	?	;task (set by ThisTaskServices)interruptTimerValue	DW	?	;counted down by watchdog (set by WaitForInterrupt)watchdogLinkPtr		DW	?	;next IC in watchdog queuetroubleIPCS		DW	?	;proc called for unexpected interrupt			DW	?	; (set by ThisTaskServices)interruptMask		DB	?	;used for enable/disableinterruptSlaveEOIcmd	DB	?	;used to clear interruptinterruptController	DW	?	;link to controller STRUC (private)interruptContext	ENDS;sizeOfIC		EQU	(SIZE interruptContext)	;in bytes!variableSizeOfIC	EQU	interruptMask-interruptStatus					;***equals number of bytes in the					; interruptContext that are variableinterruptContextBlock	STRUCICBcode			DB	ICBCodeBytes DUP (?)ICBcontext		DB	(SIZE InterruptContext) DUP (?)interruptContextBlock	ENDS;sizeOfICB		EQU	(SIZE interruptContextBlock)	;in bytes!%*DEFINE(softwareIntrptVctType)()	;tell IOPMacro this is not defined.