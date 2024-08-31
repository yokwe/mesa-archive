$MOD186$PAGELENGTH (72)$PAGEWIDTH  (136);;	Copyright (C) 1984, 1985, 1986 by Xerox Corporation. All rights reserved.;;	IORegion locations for the floppy disk handler.;;	stored as [Iris]<WMicro>Dove>FloppyIORegionDove.asm;	on vax File = IORFlop.asm;;	last edited by:;	RK	13-Oct-87 17:48:08	;Added FloppyQueueSemaphore, FloppySpareByte and FloppyDiagnosticsOn for queueing bug fix;	RK	25-Aug-87 16:32:26	;Modified for Wangtek tape support.	;	JPM	15-Aug-85 11:35:54	;Bug fix (EncodedDeviceType causes data generation);	JPM	26-Jun-85  8:49:26	;Opie redesign conversion;	JMP   	1984 Nov 27 @ 12:46;	VXS	17-Jul-84 16:24:23	:Added PUBLIC for task variable;	VXS	13-Jul-84 12:03:00	:Creation (data taken from IORegion.asm)NAME			IORFlTp;--------------------------------------------------------------------------------; $NOLIST$INCLUDE		(IOPDefs.asm)$INCLUDE		(QueDefs.asm)$INCLUDE		(FlopFace.asm)$LIST;--------------------------------------------------------------------------------; ;;********************************************************************************FloppyIOR		SEGMENT		COMMON 			Assume DS:FloppyIORPUBLIC			FloppyTaskPUBLIC			FloppyDMAtaskPUBLIC			FloppyStopHandlerPUBLIC			FloppyResetFDCPUBLIC			FloppyHandlerIsStoppedPUBLIC			FloppyFDCHungPUBLIC			FloppyWaitingForDMAInterruptPUBLIC			FloppyFirstDMAInterruptPUBLIC			FloppyDriveMotorControlCountPUBLIC			FloppyTimeoutOccurredPUBLIC			FloppyBadDMAInterruptCountPUBLIC			FloppyBadFDCInterruptCountPUBLIC			FloppyTapeThisIOCBPUBLIC			FloppyExtraBytePUBLIC			FloppyFillerByteForFormattingPUBLIC			FloppyDiagnosticsOnPUBLIC			FloppyEncodedDeviceTypesPUBLIC			FloppyWorkMaskPUBLIC			FloppyWorkNotifyPUBLIC			FloppyLockMaskPUBLIC			FloppyCurrentIOCBPUBLIC			FloppyDiagnosticQueuePUBLIC			FloppyPilotQueuePUBLIC			Floppy80186QueuePUBLIC			FloppyDCB0PUBLIC			FloppyDCB1PUBLIC			FloppyDCB2PUBLIC			FloppyDCB3PUBLIC			FloppyTotalBytesToTransferPUBLIC			FloppyCounterControlRegisterPUBLIC			FloppyFirstDMAtransferCountPUBLIC			FloppyFirstDMAcontrolWordPUBLIC			FloppyNumberOfMiddleDMAtransfersPUBLIC			FloppyMiddleDMAtransferCountPUBLIC			FloppyMiddleDMAcontrolWordPUBLIC			FloppyLastDMAtransferCountPUBLIC			FloppyLastDMAcontrolWordPUBLIC			FloppyCurrentTrackPUBLIC			FloppySpareBytePUBLIC			FloppyQueueSemaphoreFloppyTask				TaskContextBlock	<>FloppyDMAtask				TaskContextBlock	<>FloppyStopHandler			DB			?FloppyResetFDC				DB			?FloppyHandlerIsStopped			DB			?FloppyFDCHung				DB			?FloppyWaitingForDMAInterrupt		DB			?FloppyFirstDMAInterrupt			DB			?FloppyDriveMotorControlCount		DB			?FloppyTimeoutOccurred			DB			?FloppyBadDMAInterruptCount		DB			?FloppyBadFDCInterruptCount		DB			?FloppyTapeThisIOCB			DB			?FloppyExtraByte				DB			?FloppyFillerByteForFormatting		DB			?FloppyDiagnosticsOn			DB			?FloppyEncodedDeviceTypes		DB	SIZE EncodedDeviceType	DUP	(?)FloppyWorkMask				DW			?FloppyWorkNotify			Condition		<>FloppyLockMask				DW			?FloppyCurrentIOCB			DW	2	DUP	(?)		; Extended Bus Address of the Current IOCBFloppyDiagnosticQueue			QueueBlock		<>FloppyPilotQueue			QueueBlock		<>Floppy80186Queue			QueueBlock		<>FloppyDCB0				DeviceContextBlock	<>FloppyDCB1				DeviceContextBlock	<>FloppyDCB2				DeviceContextBlock	<>FloppyDCB3				DeviceContextBlock	<>FloppyTotalBytesToTransfer		DW			?FloppyCounterControlRegister		DW			?FloppyFirstDMAtransferCount		DW			?FloppyFirstDMAcontrolWord		DW			?FloppyNumberOfMiddleDMAtransfers	DW			?FloppyMiddleDMAtransferCount		DW			?FloppyMiddleDMAcontrolWord		DW			?FloppyLastDMAtransferCount		DW			?FloppyLastDMAcontrolWord		DW			?FloppyCurrentTrack			DB			?FloppySpareByte				DB			?FloppyQueueSemaphore			DW			?FloppyIOR		ENDS			END