;IORCnfig.asm;Copyright (C) 1984, 1985 by Xerox Corporation. All rights reserved.;-- IORegion locations for the SysCnfig handler.;-- stored as IORCnfig.asm;-- ReCreated on  22-Jun-85 16:01:57;;-- last edited by:	JPM    6-Aug-85 13:26:56	Opie redesign conversion;-- last edited by:	AMR    3-Jul-85 11:02:27NAME			IORCnfig;--------------------------------------------------------------------------------; $INCLUDE		(IOPDefs.asm);--------------------------------------------------------------------------------;;;********************************************************************************ConfigurationIOR	SEGMENT		COMMON PUBLIC SysCnfigTaskPUBLIC SysConfigDownCndtPUBLIC SysConfigDownMaskPUBLIC DownCommandPUBLIC DownEntryPUBLIC UpStatusPUBLIC SysConfigUpCndtPUBLIC SysConfigUpDoneFlagPUBLIC SysConfigEEPromImageSysCnfigFCB		LABEL			WORDSysCnfigTask		TaskContextBlock	<>SysConfigDownCndt	CONDITION		<>SysConfigDownMask	DW			?DownCommand		DB			?DownEntry		DB			?UpStatus		DW			?SysConfigUpCndt		DB			SIZE ClientCondition DUP (?)SysConfigUpDoneFlag	DW			?SysConfigEEPromImage	DW			64 DUP (?)ConfigurationIOR	ENDS			END