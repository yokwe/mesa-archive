$MOD186$PAGELENGTH (72)$PAGEWIDTH  (136);Copyright (C) 1984, 1985 by Xerox Corporation. All rights reserved.;-- stored as [Idun]<WDLion>Dove>HandInit.asm;-- created on  23-Jul-84 15:29:07;-- last edited by:;--	JPM	22-Jul-85 10:00:26	:Change IOPEInROM alignment to WORD;--	JPM	24-Jun-85 11:54:20	:Add PUSH/POP BX for safety;--	JPM	17-May-85 10:35:02	:Use CS for Init proc segment;--	JPM	16-May-85 10:50:36	:Opie redesign;--	kEK	 5-Mar-85 18:39:45	:changed print directives;--	JMM 	18-Feb-85 12:41:59	:Added labels at calls "~StartMe";						:and also enabled printing of them.;--	VXS 	 7-Dec-84 17:08:56	:Change so that FakeMesaPageMap is defined in Handlers.asm (FOR INTEGRATION);--	VXS 	 6-Nov-84 14:04:01	:Change name to HandInit.asm;--	VXS 	11-Oct-84 12:09:16	:Add runtime selection flag doFakeMesaMap, default=1.;--	VXS 	11-Oct-84 11:50:11	:Changed mesaPageMap segment to fakeMesaPageMap segment name.;--	VXS 	10-Oct-84 19:06:55	:Add maintPanel entry, now use macro for easier editing out of handler.;--	VXS 	10-Oct-84 18:04:02	:Add fake mesa page map for temporary handler testing.;--	VXS 	30-Aug-84 17:19:35	:Include dummy RS232CInit in NoTasks.asm;--	VXS 	28-Aug-84 11:46:48	:Changed name of Bermuda to UmbilicalHandlerLoaded;--	VXS 	23-Jul-84 15:29:18	:CreationNAME		HandInit$NOLIST$INCLUDE	(IOPDefs.asm)$INCLUDE	(OpieDefs.asm)$LIST;********************************************************************************IOPELocalRam		SEGMENT		AT 0			ASSUME	ES:IOPELocalRam			EXTRN	HandlerInitProcTable: SegmentAndOffset			EXTRN	IORSegmentTableAddress: SegmentAndOffset			EXTRN	IOROpieSegmentAddress: WORDIOPELocalRam		ENDS;********************************************************************************OpieIOR			SEGMENT		COMMON 			EXTRN	mesaPageMapOffset: WORD			EXTRN	mesaPageMapSegment: WORDOpieIOR			ENDS;********************************************************************************IOPEInROM		SEGMENT	WORD PUBLIC			ASSUME	CS:IOPEInROM			%SET(Umbilical,0)%SET(FakeMesaPageMap,0)			;No fake page map unless Handlers.asm says so$INCLUDE	(Handlers.asm)	;file specifying which handlers we link with.PUBLIC	InitializeROMFunctionsInitializeROMFunctions:			MOV	AX, IOPELocalRam			MOV	ES, AX			ASSUME	ES:IOPELocalRam;Fake Mesa Page map (optional)$GENONLY%IF(%FakeMesaPageMap) THEN (FakeMesaPageMapSeg	SEGMENT		PUBLICfakeMesaPageMapWordSize	EQU	32D		;give everyone 32 pages to play with			DW	fakeMesaPageMapWordSize DUP (?)fakeMesaPageMapSeg	ENDS			MOV	DS, IOROpieSegmentAddress			ASSUME	DS:OpieIOR			MOV	mesaPageMapOffset, 0			MOV	mesaPageMapSegment, FakeMesaPageMapSeg) FI %' end of %IF(FakeMesaPageMap)$NOGEN			LDS	BX, IORSegmentTableAddress;The following macro enumerates those which are expected to be linked.%' Handlers.asm defines a macro called HandlersLinked, which calls the%' %Handler macro for the names of all handlers the author provided.%' Assumption: SIZE SegmentEntry = SIZE SegmentAndOffset;%'  if not, insert "MOV DI, SIZE SegmentAndOffset * %id" before %name%(StoreMe:)%*DEFINE(Handler(name,id,initProcAction))	(			PUBLIC	%name%(HandlerID)%name%(HandlerID)	EQU	%id%name%(IOR)		SEGMENT	COMMON%name%(IOR)		ENDS%name%(STK)		SEGMENT	COMMON%name%(STK)		ENDS			MOV	DI, SIZE SegmentEntry * %id			MOV	[BX][DI].ioRegionSegment, %name%(IOR)			MOV	[BX][DI].stackSegment, %name%(STK)		%IF (%EQS (%initProcAction,CALL)) THEN (			EXTRN	%name%(Init): NEAR			PUSH	ES			PUSH	BX%name%(StartMe:)	PUSH	CS			CALL	%name%(Init)			POP	BX			POP	ES		    )ELSE (%IF (%EQS (%initProcAction,PROC)) THEN (			EXTRN	%name%(Init): NEAR%name%(StoreMe:)	MOV	HandlerInitProcTable[DI].segmentValue, CS			MOV	HandlerInitProcTable[DI].offsetValue, OFFSET %name%(Init)		    )FI		)FI		%IF (%EQS (%name,Umbilical)) THEN (%SET(Umbilical,1))FI	);Generate calls to Init Routines$GENONLY			%HandlersLinked			RETPUBLIC	UmbilicalHandlerLoadedUmbilicalHandlerLoaded	DB	%Umbilical		;Says whether an Opie Umbilical Handler is loaded, for Frank's testingIOPEInROM		ENDS			END