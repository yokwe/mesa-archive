$MOD186$PAGELENGTH (72)$PAGEWIDTH  (136);Copyright (C) 1984, 1985 by Xerox Corporation. All rights reserved.;-- stored as [Iris]<WMicro>Dove>IOPData.asm;-- created on  27-Feb-84 11:15:44;;-- last edited by:;--	JPM	22-Jul-85 10:00:57	:Change IOPEInROM alignment to WORD.;--	JPM	 1-Jul-85  9:04:12	:Changed OpieIOR to COMMON.;--	JPM	28-Jun-85 13:52:11	:Generate only ROM-needed data from Controllers and Devices macros.;--	JPM	27-Jun-85 17:27:34	:Use enableMask parm in x macro (from Devices).;--	JPM	25-Jun-85  8:21:27	:added wordsInCBTable.;--	JPM	24-Jun-85  8:46:32	:changed printing directives.;--	JPM	15-May-85 14:24:24	:Opie redesign.;--	kEK	 3-Mar-85 14:16:28	:changed printing directives.;--	VXS	20-Nov-84 17:38:30	:Add INCLUDE of HardOpie.asm;--	VXS	18-Sep-84 20:22:53	: Add save, gen, restore around definitions inside macro expansions.;--	VXS	31-Aug-84 15:41:07	:Use new SystemCalls macro to generate SoftwareInterruptTable ;--	VXS	28-Aug-84 18:11:12	:extend hardware interrupt table - HACK!!! ;--	VXS	28-Aug-84 11:57:18	:Took out unnecessary include of IOPMacro;--	VXS	27-Aug-84 17:37:27	:Change EOIPort and EOIcommand macro args in Controllers to slaveEOIPort and slaveEOIcommand (for clarity);--	VXS	 7-Aug-84 17:31:34	:Rewrote ICB generation to use InterruptControllers macro;--	VXS	 6-Aug-84 17:23:41	:Change VctBase to VctType;--	VXS	 6-Aug-84 16:51:16	:Add new file location;--	VXS	16-Jul-84 15:57:52	:Get rid of INCLUDE of IOImport;--	VXS	12-Jul-84 16:35:54	:Moved Devices macro out to IOPDefs;--	VXS	 9-Jul-84 18:25:14	:Fixed prob in Devices macro;--	VXS	 5-Jul-84 14:59:43	:added Devices to generate interrupt info;						 Generate Interrupt Vector table automatically with;						 Devices macro;--	JPM	 3-Jul-84 14:09:39	:Added IOPE@ReadEEProm.;--	FXB	 2-Jul-84 13:53:29	:added space allocation for BindweedIntr;--	JMM 	27-Jun-84 15:15:43	:Opie Version 1 release;--	ETN	21-Jun-84 18:34:47	:changed init so tasks not needed.;--	JMM	21-Jun-84 18:34:47	:Misc. cleanup.;--	JMM	20-Jun-84 12:38:22	:Deleted Converts, etc.;--	JMM	18-Jun-84 17:51:51	:Version 1 release.NAME			IOPData;--------------------------------------------------------------------------------;Must be included in this order or else things get screwed up in IOPMacro.$NOLIST$INCLUDE		(IOPDefs.asm)$INCLUDE		(HardOpie.asm)$INCLUDE		(IOPMacro.asm)$INCLUDE		(OpieDefs.asm)$LIST;--------------------------------------------------------------------------------;;********************************************************************************OpieIOR			SEGMENT		COMMON;Generate CB EXTRNs%*DEFINE(Controller(name,intType,slaveEOIPort,PendPort,MaskPort))($GENONLY%IF(%EQS(%whereDefined,ROM)) THEN (EXTRN			%name%(Controller): ControllerBlock)FI); end Controller macro definition$SAVE			%InterruptControllers$RESTORE;Generate ICB EXTRNs%*DEFINE(x(name,controlname,channel,slaveEOIcommand,enableMask))($GENONLY%IF(%EQS(%whereDefined,ROM)) THEN (EXTRN			%name%(ICB): InterruptContextBlock)FI); end Controller macro definition$SAVE			%Devices$RESTOREOpieIOR			ENDS;--------------------------------------------------------------------------------IOPEInROM		SEGMENT	WORD PUBLIC			Assume CS:IOPEInROMPUBLIC			beginCBTable, wordsInCBTablePUBLIC			beginICTable, numberOfICsForROMFunctions, sizeOfICInROMPUBLIC			beginHardwareIVTable, numberOfHardwareIVsForROMFunctionsPUBLIC			beginSoftwareIVTable, numberOfSoftwareIVsForROMFunctionsPUBLIC			codeToInsertIntoICBEXTRN			UnServiced: NEAREXTRN			GenericInterruptProcessing: FAR;--------------------------------------------------------------------------------;All the entry points below have to be in ROM so there is no need;to save the CS!;Generation of CB and ICB constant data; Appears in ROM and is copied down to CBs and ICBs in RAM.;Generate CB data%*DEFINE(Controller(name,intType,slaveEOIPort,PendPort,MaskPort))($GENONLY%IF(%EQS(%whereDefined,ROM)) THEN (%name%(romCB)		ControllerBlock	<%slaveEOIport,%PendPort,%MaskPort>)FI); end Controller macro definitionbeginCBTable:$SAVE			%InterruptControllers$RESTOREendCBTable:sizeOfCBTable		EQU	(endCBTable-beginCBTable)wordsInCBTable		EQU	sizeOfCBTable/2;Generate IC data%*DEFINE(x(name,controlname,channel,slaveEOIcommand,enableMask))($GENONLY%IF(%EQS(%whereDefined,ROM)) THEN (			ORG	OFFSET ($-variableSizeOfIC)%name%(romIC)		InterruptContext <,,,,,,,%enableMask,%slaveEOIcommand,OFFSET %controlname%(Controller)>)FI); end x macro definition;Note that this depends on data being generated before here, since assembler won't; wrap backwards thru 0beginICTable:$SAVE			%Devices$RESTOREendICTable:sizeOfICInROM		EQU	(sizeOfIC-variableSizeOfIC) ;Size in bytes of rom ICsizeOfICTable		EQU	(endICTable-beginICTable)numberOfICsForROMFunctions	EQU	sizeOfICTable/sizeOfICInROM;Generate hardware interrupt vector data%*DEFINE(x(name,controlname,channel,slaveEOIcommand,enableMask))( $GENONLY%IF(%EQS(%whereDefined,ROM)) THEN (			DW	4*%controlname%(IntrptVctType)+4*(%channel)			DW	OFFSET %name%(ICB))FI)      beginHardwareIVTable:$SAVE			%Devices$RESTOREendHardwareIVTable: sizeOfHardwareIVTable	EQU	(endHardwareIVTable-beginHardwareIVTable)numberOfHardwareIVsForROMFunctions	EQU	sizeOfHardwareIVTable/4%*DEFINE(SystemCall(Name))($GENONLY%IF(%EQS(%whereDefined,ROM)) THEN (EXTRN			%(IOPE@)%Name: NEAR			DW	OFFSET IOPE@%Name)FI)%' End %*DEFINE(SystemCall(Name))beginSoftwareIVTable:$SAVE			%SystemCalls$RESTOREendSoftwareIVTable:sizeOfSoftwareIVTable	EQU	(endSoftwareIVTable-beginSoftwareIVTable)numberOfSoftwareIVsForROMFunctions	EQU	sizeOfSoftwareIVTable/2codeToInsertIntoICB:			PUSHA			CALL	GenericInterruptProcessingIOPEInROM		ENDS;********************************************************************************			END