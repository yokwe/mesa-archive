;Copyright (C) 1984, 1985 by Xerox Corporation. All rights reserved.;-- This program provides defs for the mesa processor handler and mesa client task.;-- stored as [Iris]<WMicro>Dove>MesaDefs.asm;-- last edited by:;--	TXM			 5-Nov-87 20:32:11	:Add readMachineTypetoData;--	ERS			13-Jan-87 10:55:12	:add readCSBankstoData;--	KEK			27-May-86 12:47:03	:add Daisy bits to interruptMesa equ's;--	JPM			13-Aug-85 16:38:53	:Add readPCTypetoData;--	JPM			26-Jul-85 10:54:43	:Rename some commands;--	JPM			28-Jun-85 10:47:15	:Separate EEProm functions (so Mesa doesn't have to know indexes);--	JPM			29-Nov-84 13:07:34	:Add haltMesa and noHaltMesa;--	JPM			17-Oct-84 13:29:10	:Add readEEPromtoData and lastCommand;--	JPM			 4-Oct-84 13:43:17	:Creation;-- MesaProcessorTask command values and constantsnoCommand		EQU	00H	; no commandreadGMTtoData		EQU	01H	; copy timeOfDay into data areawriteGMTfromData	EQU	02H	; copy data area into timeOfDayreadHostIDtoData	EQU	03H	; read host ID prom into data areareadVMMapDesctoData	EQU	04H	; read VMMSizeInPages into data areareadRealMemDesctoData	EQU	05H	; read EEProm real mem size into data areareadDisplayDesctoData	EQU	06H	; read EEProm/HW disp. type into data areareadKeyboardTypetoData	EQU	07H	; read EEProm KB type into data areareadPCTypetoData	EQU	08H	; read EEProm PC type into data areabootButton		EQU	09H	; perform simulated system bootreadCSBankstoData	EQU	0AH	; read EEProm CS Banks into data areareadMachineTypetoData	EQU	0BH	; read machineIDPort Machine type into data arealastCommand		EQU	readMachineTypetoDatasizeHostID		EQU	6haltMesa		EQU	4000H	; mask used to set Mesa halt' bit (L active)noHaltMesa		EQU	4200H	; mask used to reset Mesa halt' bit;-- MesaClientTask constantsinterruptMesa		EQU	4300H	; mask used to set Mesa interrupt bitnoInterruptMesa		EQU	4200H	; mask used to reset Mesa interrupt bit;note the 4H in the high byte of the last four equ's: this supports Daisy; and I hope is still compatible with Daybreak...;--	end of MesaDefs.asm