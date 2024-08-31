; DAIS0G002.def= 5 revs up from DaisyRevC.Def;Copyright (C) 1984, 1985 by Xerox Corporation. All rights reserved.;-- stored as [Iris]<WMicro>Dove>HardDefs.asm%*DEFINE(Revision)(Hardware: G, DefsVersion: 002);end Revision macro definition;Last Edited By:;	TXM    	 30-Oct-87  9:03:14	:Add Dahlia distinction;	KEK    	 17-Apr-86  9:21:29	:add Daisy defs;	JAC    	 24-Jan-86 10:49:04	:change 8259OptionsSlave definitions;	JGS    	 27-Sep-85 12:25:47	:DisplayTypePort is 0ECCCH not 0ECC0H.;	JPM    	 11-Sep-85  8:57:09	:Add i8274NonVectored and appropriate constant changes.;	JPM    	  2-Aug-85 16:32:59	:Fix EEProm segment offsets.;	KEK	 19-Jun-85 13:29:31	:remove fixed EEPDefs definitions (put into ROMEEP.asm, RAMEEP.asm, and BadPage.asm), added eep segment offsets. Remove duplicate defs 8259Mas, 8259Slv, also Ctl and IntCtl...;	JPM    	  6-Jul-85 10:36:35	:Add i80186Flags (from HardOpie).;	JPM    	  2-Jul-85  8:09:55	:Add i8274VarVect.;	JPM    	 25-Jun-85 16:56:49	:Take out software-determined EEProm constants (except byte/word flag for IOPKernl).;	KEK	 19-Jun-85 13:29:31	:add in EEProm section, containing old EEPDefs.asm and HardEEP.asm.;	JPM    	 30-May-85 16:53:35	:change i8259MasterICW3 for B0.;	KEK	 21-May-85 11:04:37	:add DisplayTypePort and DisplayTypeMask.;	KEK	 25-Apr-85 16:10:33	:more 8274 defs (used by IOPInit). Corrected 18259OptionsSlaveICW2 vector number. add some i8259OptionsSlave defs.;	KEK	  5-Mar-85 11:18:16	:add ETCH TWO comment (WriteCtlReg defs).;	KEK	  26-Feb-85 21:00:32	:Add machine distinguishing constants, retraceLatch port constant, add 8274 equates.;	VXS     15-Nov-84 12:06:42	:Add symbols for Control Register.;	VXS      7-Nov-84 13:33:59	:Remove ClearResetsMask;	VXS      5-Nov-84 15:44:53	:Add defs for daybreak map register numbers;	VXS     11-Oct-84 10:07:23	:Add Device Reset information;	VXS      9-Oct-84 11:52:19	:Changed FDCDMADataReg to base+4 - 6 works too, but it decodes the bits seperately anyway.;	VXS      4-Oct-84 14:41:15	:Add daybreakMapIOAddressBase;	VXS      3-Oct-84 16:59:26	:Added FloppyTimer, since the timer is hardwired to timer 1.;	VXS      1-Oct-84 18:46:27	:Added definitions for Floppy DMA (uses internal 186 DMA controller);	VXS     17-Sep-84 14:05:10	:Change def of TRUE to -1 instead of 0FFFF so that can use it for bytes;	FXB   	15-Aug-84 16:29:29	:Made changes for Rev 0G002 for AKTsang;	VXS      6-Aug-84 18:30:34	:Add OptionsSlaveInServiceRegAddr;	VXS      6-Aug-84 12:53:55	:Use new symbols instead of *CtlrBase ones;	VXS      3-Aug-84 18:54:20	:Added def for 8259 masterInServceRegAddr;	VXS      3-Aug-84 17:52:15	:Added Mas and Slv defs back in as duplicates for compatibility, also Ctl and IntCtl;	VXS      3-Aug-84 14:08:21	;changed i186*CtlAddr to i186*IntCtlAddr for clarity;	VXS      3-Aug-84 14:05:39	:Added i186Intrchannelfor*;	VXS     3-Aug-84 11:49:18	:Changed convention for 8259 expansion from *Exp* to *Optionsslave*;	VXS     3-Aug-84 11:31:41	:Put in Revision macro, which is documentation of what version of this file and what hardware revision its for;	VXS     3-Aug-84 10:31:18	:Removed defs specific to chips and moved them to *Defs.asm;	VXS     3-Aug-84 10:21:15  	:changes *Mas symbols to *Master, *Slv to *Slave;	FXB     1-Aug-84 16:23:51 	 :added expansion intr cntlr constants;	JBinkley 22-Jun-84 16:20:40;	P. PxE  for JBinkley 6-Jun-84 13:49:52;					:Changed ICW3 to reflect slave mode of 8274; 					  changed ISR & IRR for 8259 read.;	JBinkley 20-Apr-84 13:14:22; updated to RevC Build by JBinkley 12-Apr-84  6:39:12; first written by JBinkley 21-Oct-83 with Geoff Thompson; This file defines IO addresses for the Daisy IOP.; It also includes operation constants for hardware that is central to the system,; such as the 8259 interrupt controller, the 80186 processor operation constants, etc.; There are now seperate files for the peripheral chip operating constants, of; the form <chipname>Defs.asm.; It should be INCLUDE-ed  in all;   hardware dependent code modules.;*******************************************************; DO NOT REFER TO "iAPX 86/88, 186/188 User's Manual;                  Programmer's Reference",   May 1983.; IT CONTAINS NUMEROUS MISTAKES.; Refer, instead, to the 186 Application's Note;     by Ken Shoemaker, March, 1983;     or to the 186 Data Sheet.;*******************************************************; Conventions for labels:;	Intn	=	Internal;	Intr	=	Interrupt;	Ctl	=	Control;	Ctlr	=	Controller; Chip identifiers --;	i186	=	Intel 80186;	i8259=	Intel 8259;	i8251=	Intel 8251; Normally, each new word in a label occurs with the first character; capitalized. The exception is when the previous word is all CAPS,; as in: PACSvalue. (When a name is defined by Intel, we use their; convention.);*******************************************************; i80186 Internal Peripheral Control Block  (PCB); This section defines the various control register addresses in the;   80186  on-chip Peripheral Control Block  (PCB); After RESET, the relocation reg = 20FFH.  This means the;   PCB will be mapped into I/O space, &;   base address of  PCB = 0FF00H.; PCB can be relocated to any 256-byte boundary.; For Daisy, the PCB is specified at the upper-most 256 bytes of;   the I/O space  (i.e., default i186 locations)PCBbase	EQU	0FF00h; Chip  Select  Control  Register  Locations;UMCSaddr	EQU	PCBbase + 0A0h	;Upper Mem (ROM) Chip SelectLMCSaddr	EQU	PCBbase + 0A2h	;Lower Mem (RAM) Chip SelectPACSaddr	EQU	PCBbase + 0A4h	;Peripherial Chip Select					; & PCS 0-3 Ready bitsMMCSaddr	EQU	PCBbase + 0A6h	;Middle Mem (RAM) Chip SelectMPCSaddr	EQU	PCBbase + 0A8h	;Middle Mem Range					; & PCS 4-6 Ready bits;---------------------------------------------------------; Chip  Select  Control  Register  Values; (See i186ControlBlockProgramming.doc for more detailed documentation); See Intel  uP & P Handbook, 1983,  pp.3-39  to 3-43.; All memory sizes are specified in bytes.; Upper Memory Chip Select;   16 KBytes of EPROM, base @ 0FC000h, 0 WS, RDY ignoredUMCSvalue	EQU	0FC3Ch	; _ (0038h -OR- 0004h -OR- FC00h); Lower Memory Chip Select;   16 KBytes of SRAM, base @ 000000h, 0 WS, wait for RDYLMCSvalue	EQU	003F8h	; _ (0038h -OR- 0000h -OR- 03C0h); Middle Memory Chip Select;   Possible 64 KBytes of SRAM, as 4  16K chunks;   Only first 16 KBytes chunk is implemented,;   base @ 010000h, 0 WS, wait for RDYMMCSvalue	EQU	011F8h	; _ (01F8h -OR- 0000h -OR- 1000h); Middle Memory / Peripheral Chip Select;   Possible 64 KBytes of SRAM, as 4  16K chunks;   (addresses 010000 to 013FFF installed);   7 PCS' lines, mapped into I/O space;   PCS4-6: 0 WS, RDY ignoredMPCSvalue	EQU	088BCh	; _ (8038h -OR- 0800h -OR- 0080h -OR- 0004h); Peripheral Chip Select;   Base @ 0000H,;   PCS0-3: 1 WS, RDY ignoredPACSvalue	EQU	0003Dh	; _ (0038h -OR- 0005h -OR- 0000h);-------------------------------------------------------------------------;  Other 80186 Internal Control registers addressesi186RelocationRegAddr	EQU	PCBbase+0FEh	;Relocation Registeri186Timer0IntCtlAddr	EQU	PCBbase+032h	;Timer 0 Interrupt Control Registeri186Timer1IntCtlAddr	EQU	PCBbase+038h	;Timer 1 Interrupt Control Registeri186Timer2IntCtlAddr	EQU	PCBbase+03Ah	;Timer 2 Interrupt Control Register;Definitions for i186 internal DMA 0i186DMA0IntCtlAddr	EQU	PCBbase+034h	;DMA 0 Interrupt Control Registeri186DMA0LowSourcePtr	EQU	PCBbase+0C0h	;DMA 0 Low order source pointeri186DMA0HighSourcePtr	EQU	PCBbase+0C2h	;DMA 0 High order source pointeri186DMA0LowDestPtr	EQU	PCBbase+0C4h	;DMA 0 Low order destination pointeri186DMA0HighDestPtr	EQU	PCBbase+0C6h	;DMA 0 High order destination pointeri186DMA0TransferCount	EQU	PCBbase+0C8h	;DMA 0 transfer counti186DMA0ControlWord	EQU	PCBbase+0CAh	;DMA 0 control word;Definitions for i186 internal DMA 0i186DMA1IntCtlAddr	EQU	PCBbase+036h	;DMA 1 Interrupt Control Registeri186DMA1LowSourcePtr	EQU	PCBbase+0D0h	;DMA 1 Low order source pointeri186DMA1HighSourcePtr	EQU	PCBbase+0D2h	;DMA 1 High order source pointeri186DMA1LowDestPtr	EQU	PCBbase+0D4h	;DMA 1 Low order destination pointeri186DMA1HighDestPtr	EQU	PCBbase+0D6h	;DMA 1 High order destination pointeri186DMA1TransferCount	EQU	PCBbase+0D8h	;DMA 1 transfer counti186DMA1ControlWord	EQU	PCBbase+0DAh	;DMA 1 control wordi186IntVectorRegAddr	EQU	PCBbase+020h	;Interrupt Vector Registeri186EOIRegAddr		EQU	PCBbase+022h	;Specific EOI Registeri186IntrMaskRegAddr	EQU	PCBbase+028h	;Interrupt mask registeri186PriorityMaskAddr	EQU	PCBbase+02Ah	;Priority Level Registeri186InServiceRegAddr	EQU	PCBbase+02Ch	;In Service registeri186IntrRequestAddr	EQU	PCBbase+02Eh	;Interrupt Request Registeri186IntrStatusAddr	EQU	PCBbase+030h	;Interrupt Status Register;-------------------------------------------------------------------------; 80186 Timer I/O Addressesi186Timer0MCWAddr	EQU	PCBbase+056h	;Mode/Control Wordi186Timer1MCWAddr	EQU	PCBbase+05Eh	;Mode/Control Wordi186Timer2MCWAddr	EQU	PCBbase+066h	;Mode/Control Wordi186Timer0CountBAddr	EQU	PCBbase+054h	;Max Count Bi186Timer1CountBAddr	EQU	PCBbase+05Ch	;Max Count Bi186Timer0CountAAddr	EQU	PCBbase+052h	;Max Count Ai186Timer1CountAAddr	EQU	PCBbase+05Ah	;Max Count Ai186Timer2CountAAddr	EQU	PCBbase+062h	;Max Count Ai186Timer0CountRegAddr	EQU	PCBbase+050h	;Count Regi186Timer1CountRegAddr	EQU	PCBbase+058h	;Count Regi186Timer2CountRegAddr	EQU	PCBbase+060h	;Count Reg;-------------------------------------------------------------------------; 80186 Internal Control registers valuesi186RelocationRegvalue	EQU	060FFh	;RMX mode & default locationi186IntrVectorRegvalue	EQU	0038h	;Vectors types start at 038h;The following channel requirements are imposed by the 186 hardware in iRMX mode.i186IntrChannelforTimer0	EQU	0i186IntrChannelforDMA0		EQU	2i186IntrChannelforDMA1		EQU	3i186IntrChannelforTimer1	EQU	4i186IntrChannelforTimer2	EQU	5i186IntrMaskforTimer0	EQU	NOT(1 SHL i186IntrChannelforTimer0)i186IntrMaskforDMA0	EQU	NOT(1 SHL i186IntrChannelforDMA0)i186IntrMaskforDMA1	EQU	NOT(1 SHL i186IntrChannelforDMA1)i186IntrMaskforTimer1	EQU	NOT(1 SHL i186IntrChannelforTimer1)i186IntrMaskforTimer2	EQU	NOT(1 SHL i186IntrChannelforTimer2); EOI Commands for internal interrupt controlleri186EOItimer0		EQU	i186IntrChannelforTimer0i186EOIdma0		EQU	i186IntrChannelforDMA0i186EOIdma1		EQU	i186IntrChannelforDMA1i186EOItimer1		EQU	i186IntrChannelforTimer1i186EOItimer2		EQU	i186IntrChannelforTimer2;--------------------------------------------------------------------------;80186 Flag structurei80186Flags	RECORD	reserved15to12:4, i80186OF:1, i80186DF:1, i80186IF:1,&			i80186TF:1, i80186SF:1, i80186ZF:1, reserved5:1,&			i80186AF:1, reserved3:1, i80186PF:1, reserved1:1,&			i80186CF:1		PURGE	reserved15to12, reserved5, reserved3, reserved1;--------------------------------------------------------------------------; Peripherial  Device  Base  Addresses;   Peripherial Chip Selects are mapped into I/O space;   and start at address 0000H.;  Note : Base address of PCS's must be an integer multiple of 1K.PCSBase	EQU	0h		; defined in PACSPCS0Base	EQU	PCSBase + 0hPCS1Base	EQU	PCSBase + 080hPCS2Base	EQU	PCSBase + 100hPCS3Base	EQU	PCSBase + 180hPCS4Base	EQU	PCSBase + 200hPCS5Base	EQU	PCSBase + 280hPCS6Base	EQU	PCSBase + 300h; ---------------------------------------------------; PCS.0'  --  used for Peripherial Controllers,  1 w.s.;   (8 bit Data Bus Devices); --- new names as of August 3, 1984 ---i8259MasterBase	EQU	PCS0Base + 00h	;A6-A4 = 0i8259SlaveBase	EQU	PCS0Base + 10h	;A6-A4 = 1i8254Base	EQU	PCS0Base + 20h	;A6-A4 = 2i8251Base	EQU	PCS0Base + 30h	;A6-A4 = 3i8274DCommBase	EQU	PCS0Base + 40h	;A6-A4 = 4i8272Base	EQU	PCS0Base + 50h	;A6-A4 = 5i8259OptionsSlaveBase	EQU	PCS0Base + 60h	;A6-A4 = 6i8255Base		EQU	PCS0Base + 70h	;A6-A4 = 7; ---------------------------------------------------; PCS.1'  --  used for miscellaneous I/O,  0 w.s.;   (16 bit Data Bus Devices)DisplayTypePort	EQU	0ECCCH		;read this to get display size dataDisplayTypeMask	EQU	01H		;if bit0 = 0,then 19" display else 15".ReadInputPort	EQU	PCS1Base + 0h		;A6-A4 = 000b, R --80hReadHostProm	EQU	PCS1Base + 10h		;A6-A4 = 001b, R --90hClrRingLatch	EQU	PCS1Base + 20h		;A6-A4 = 010b, R --A0hClrMesaIntr	EQU	PCS1Base + 30h		;A6-A4 = 011b, R --B0hClrENetIntr	EQU	PCS1Base + 40h		;A6-A4 = 100b, R --C0hClrRetraceIntr	EQU	PCS1Base + 50h		;A6-A4 = 101b, R --D0h;a word IN instruction to this port will address the arbiter:ArbCmdBase	EQU	PCS1Base + 70h		;A6-A4 = 111b, R --Fxh;The arbiter control will accept any combination of the bits below, and perform; the multiple functions specified:AllowPCCmdOffset	EQU	08H		;add this to ArbCmdBaseAllowRDCmdOffset	EQU	04H		;add this to ArbCmdBaseHoldIOPCmd		EQU	02H		;add this to ArbCmdBaseWriteCtlReg	EQU	PCS1Base + 0h		;A6-A4 = 000b, W --80h;ETCH ONE DEFS!  CRSpeakerData			EQU	8000H  CREnableTimer0		EQU	4000H  CRFDDMotorOn			EQU	2000H  CRFDDInUse			EQU	1000H  CRTimer1GenerateFloppyTC	EQU	0800H  CREEPromAccess		EQU	0400H  CRRS232AInternalClock		EQU	0200H  CRRS232BEnableClockSend	EQU	0100H;ETCH TWO DEFS! (some are already defined by the ETCH ONE defs above)  CRNotBlockSysMem		EQU	8000H	;'1 enables memory!; CREnableTimer0		EQU	4000H; CRFDDMotorOn			EQU	2000H; CRFDDInUse			EQU	1000H; CRTimer1GenerateFloppyTC	EQU	0800H  CRFDDLowSpeed			EQU	0400H	;low = '1, hi = '0; CRRS232AInternalClock		EQU	0200H; CRRS232BEnableClockSend	EQU	0100H  CRDriveSel3			EQU	0080H  CRDriveSel2			EQU	0040H  CRDriveSel1			EQU	0020H  CRDriveSel0			EQU	0010H  CRSelect250KbDataRate		EQU	0008H	;signal "5H/8L"  CRPcomp2			EQU	0004H  CRPcomp1			EQU	0002H  CRPcomp0			EQU	0001H  CRFloppyMask			EQU	3CFFHWriteLED	EQU	PCS1Base + 10h		;A6-A4 = 001b, W --90hENetAttn	EQU	PCS1Base + 20h		;A6-A4 = 010b, W --A0hWriteCSReg	EQU	PCS1Base + 30h		;A6-A4 = 011b, W --B0hWriteResetReg	EQU	PCS1Base + 40h		;A6-A4 = 100b, W --C0hWriteConfigReg	EQU	PCS1Base + 50h		;A6-A4 = 101b, W --D0hallResetBits	EQU	07FFH		;All bits;The following constant is used for a LOOP $ between clearing the reset bit; for a device and setting it again to ensure that the reset signal is held; low for the proper amount of time. It should be adjusted so that the device; with the longest reset time is accounted for.clocksPerusec			EQU	8	;running at 8MHzclocksPerLOOP			EQU	16D	;from Intel handbookusecsPerLOOP			EQU	clocksPerLOOP/clocksPerusecmaximumResetDelayinusecs	EQU	32D	;twice the floppy's requirement.maximumResetDelayCount		EQU	maximumResetDelayinusecs/usecsPerLOOP;Here are the individual device reset bit masks.resetEthernetController		EQU	1resetRS232CController		EQU	2resetFloppyController		EQU	4resetKeyboardUART		EQU	8resetUmbilicalController	EQU	10hresetKeyboardController		EQU	20hresetMesaProcessor		EQU	40hresetPCProcessor		EQU	80hresetDiskController		EQU	100hresetDiskDMAController		EQU	200hresetExpansionChannel		EQU	400h;Here are some composite device reset masks.resetKeyboardHardware	EQU	resetKeyboardUART + resetKeyboardControllerresetDiskHardware	EQU	resetDiskController + resetDiskDMAController;----------------------------------------------------------------------------; Interrupt  Controller -- Master i8259A; [Programming information on Page 2-120 of; the Intel '84 Microsystem Components Handbook]%SET(i8274NonVectored,1);i8259MasterAddr0	EQU	i8259MasterBase +0h	;A1 = 0i8259MasterAddr1	EQU	i8259MasterBase +2h	;A1 = 1i8259MasterInServiceRegAddr	EQU	i8259MasterAddr0					;OCW3 (A1=0) is in-service register when i8259ISRread					; is giveni8259MasterRequestRegAddr	EQU	i8259MasterAddr0					;OCW3(A1=0) is also interrupt request register when					; i8259IRRread is giveni8259MasterMaskRegAddr		EQU	i8259MasterAddr1					;This is always the mask register (read from where its written);i8259MasterICW1	EQU	011h	;ICW1, edge triggered, cascade mode, ICW4 neededi8259MasterICW2	EQU	020h	;interrupt types 20h-27h%IF(%i8274NonVectored) THEN (i8259MasterICW3 	EQU	060H	;i8274 not a slave in non-vectored mode) ELSE (i8259MasterICW3 	EQU	070H	;IR4 - slave i8274 --for ETCH TWO!!!;i8259MasterICW3 	EQU	0E8h	;IR3 - slave i8274 --for ETCH ONE!!!) FI				;IR5 - slave i8259				;IR6 - slave i80186				;IR7 - slave expansion slot -- for ETCH ONE!!!i8259MasterICW4	EQU	011h	;SFNM, Not Buffered, Normal EOI, 86/88 modei8259MasterOCW1	EQU	0FFh	;Nothing is enabledi8259MasterOCW2	EQU	0C7h	;IR7 has lowest priorityi8259MasterOCW3	EQU	008h	;Not special mask modei8259MasterDebuggerInEOI EQU 61h  ;specific EOI for debugger Int Handleri8259AllEnabled 	EQU	00000000B ;All interrupts are enabled...i8259AllInhibited	EQU	0FFh	;All interrupts are inhibited...i8259EnableIR0		EQU	0FEh	;Enable IR0 (for OCW1)i8259EnableIR1		EQU	0FDh	;Enable IR1 (for OCW1)i8259EnableIR2		EQU	0FBh	;Enable IR2 (for OCW1)i8259EnableIR3		EQU	0F7h	;Enable IR3 (for OCW1)i8259EnableIR4		EQU	0EFh	;Enable IR4 (for OCW1)i8259EnableIR5		EQU	0DFh	;Enable IR5 (for OCW1)i8259EnableIR6		EQU	0BFh	;Enable IR6 (for OCW1)i8259EnableIR7		EQU	07Fh	;Enable IR7 (for OCW1)i8259EOIforIR0		EQU	060h	;Specific EOI for IR0 (for OCW2)i8259EOIforIR1		EQU	061h	;Specific EOI for IR1 (for OCW2)i8259EOIforIR2		EQU	062h	;Specific EOI for IR2 (for OCW2)i8259EOIforIR3		EQU	063h	;Specific EOI for IR3 (for OCW2)i8259EOIforIR4		EQU	064h	;Specific EOI for IR4 (for OCW2)i8259EOIforIR5		EQU	065h	;Specific EOI for IR5 (for OCW2)i8259EOIforIR6		EQU	066h	;Specific EOI for IR6 (for OCW2)i8259EOIforIR7		EQU	067h	;Specific EOI for IR7 (for OCW2)i8259EOINonSpecific	EQU	20h	;Non-specific EOI for 8259si8259ISRread		EQU	00Bh	;Read In-Service-Register on					;next Rd pulse (for OCW3)i8259IRRread		EQU	00Ah	;Read Intr-Request-Register on					;next pulse Rd pulse (for OCW3);To read IMR of i8259, set A1 = 1;-----------------------------------------------------------------; Interrupt  Controller -- Slave i8259A; [Programming information on Page 2-120 of; the Intel '84 Microsystem Components Handbook];i8259SlaveAddr0	EQU	i8259SlaveBase +0h	;A1 = 0i8259SlaveAddr1	EQU	i8259SlaveBase +2h	;A1 = 1;i8259SlaveICW1	EQU	011h	;ICW1, edge triggered, cascade mode, ICW4 neededi8259SlaveICW2	EQU	030h	;interrupt types 30h-37hi8259SlaveICW3 	EQU	005h	;This slave is connected to IR5 of the masteri8259SlaveICW4	EQU	001h	;not SFNM, Not Buffered, Normal EOI, 86/88 modei8259SlaveOCW1	EQU	0FFh	;Nothing is enabledi8259SlaveOCW2	EQU	0C7h	;IR7 has lowest priorityi8259SlaveOCW3	EQU	008h	;Not special mask modei8259SlaveInServiceRegAddr	EQU	i8259SlaveAddr0					;OCW3 (A1=0) is in-service register when i8259ISRread					; is giveni8259SlaveRequestRegAddr	EQU	i8259SlaveAddr0					;OCW3(A1=0) is also interrupt request register when					; i8259IRRread is giveni8259SlaveMaskRegAddr		EQU	i8259SlaveAddr1					;This is always the mask register (read from where its written);-----------------------------------------------------------------; Interrupt  Controller -- Expansion slot i8259A; [Programming information on Page 2-120 of; the Intel '84 Microsystem Components Handbook];i8259OptionsSlaveAddr0	EQU	i8259OptionsSlaveBase +0h	;A1 = 0i8259OptionsSlaveAddr1	EQU	i8259OptionsSlaveBase +2h	;A1 = 1i8259OptionsSlaveICW1	EQU	013h	;ICW1, edge triggered, single, ICW4 neededi8259OptionsSlaveICW2	EQU	000h	;no interrupt vector generated;i8259OptionsSlaveICW3 ******** not used *********i8259OptionsSlaveICW4	EQU	001h	;not SFNM, Not Buffered, Normal EOI, 86/88 mode	i8259Poll	EQU	00CH		;i8259 in poll modei8259OptionsSlaveOCW1	EQU	0FFh	;Nothing is enabledi8259OptionsSlaveOCW2	EQU	0C7h	;IR7 has lowest priorityi8259OptionsSlaveOCW3	EQU	008h	;Not special mask modei8259OptionsSlaveInServiceRegAddr	EQU	i8259OptionsSlaveAddr0					;OCW3 (A1=0) is in-service register when i8259ISRread					; is giveni8259OptionsSlaveRequestRegAddr	EQU	i8259OptionsSlaveAddr0					;OCW3(A1=0) is also interrupt request register when					; i8259IRRread is giveni8259OptionsSlaveMaskRegAddr	EQU	i8259OptionsSlaveAddr1					;This is always the mask register (read from where its written);------------------------------------------------------------------------------;-- This section is for Daybreak dependent hardware parameters.;--daybreakMapIOAddressBase		EQU	0E010HdaybreakMapRegisterNumberBase		EQU	0daybreakMapIOAddressPCBase		EQU	0E010HdaybreakMapRegisterNumberPCBase		EQU	daybreakMapRegisterNumberBasedaybreakMapIOAddressIOPBase		EQU	0E018HdaybreakMapRegisterNumberIOPBase	EQU	8nilMapData				EQU	0FFH; illegal map reg data for init.;------------------------------------------------------------------------------;-- This section is for Daisy dependent hardware parameters.;--daisyMapIOAddressBase		EQU	0804HdaisyMapRegisterNumberBase	EQU	0daisyMapIOAddressPCBase		EQU	daisyMapIOAddressBasedaisyMapRegisterNumberPCBase	EQU	daisyMapRegisterNumberBasedaisyMapIOAddressIOPBase	EQU	daisyMapIOAddressBasedaisyMapRegisterNumberIOPBase	EQU	8maxChipCount			EQU	4 ;number 0f A-chips at one time.;------------------------------------------------------------------------------;-- This section defines IOP device addresses.;-- Device control symbols appear in the respective definitions file for the;--  device.;--------------------------------------------------------------------------------;  Intel (i8251)KeyBdUartData		EQU	i8251Base + 0h	;A1 = 0, R/WKeyBdUartCtl		EQU	i8251Base + 2h	;A1 = 1, WKeyBdUartStatus		EQU	i8251Base + 2h	;A1 = 1, R;------------------------------------------------------------------------------;Timers  (i8254); [Programming information on Page 2- of; the Intel '84 Microsystem Components Handbook]i8254Count0	EQU	i8254Base + 0h	;A2-A1 = 00h, R/Wi8254Count1	EQU	i8254Base + 2h	;A2-A1 = 01h, R/Wi8254Count2	EQU	i8254Base + 4h	;A2-A1 = 10h, R/Wi8254Ctlr	EQU	i8254Base + 6h	;A2-A1 = 11h, W;-----------------------------------------------------------------; RS232C Channels (i8274); [Programming information on Page ???]i8274DCommADataAddr	EQU	i8274DCommBase + 0h	;A2-A1 = 00bi8274DCommACtlrAddr	EQU	i8274DCommBase + 4h	;A2-A1 = 10bi8274DCommBDataAddr	EQU	i8274DCommBase + 2h	;A2-A1 = 01bi8274DCommBCtlrAddr	EQU	i8274DCommBase + 6h	;A2-A1 = 11bi8274WriteRegister0	EQU	0i8274WriteRegister1	EQU	1i8274WriteRegister2	EQU	2i8274WriteRegister3	EQU	3i8274WriteRegister4	EQU	4i8274WriteRegister5	EQU	5i8274WriteRegister6	EQU	6i8274WriteRegister7	EQU	7i8274ReadRegister0	EQU	0i8274ReadRegister1	EQU	1i8274ReadRegister2	EQU	2i8274EOIPort		EQU	i8274DCommACtlrAddri8274EOICommand		EQU	038h			;can only be sent to chA.i8274RstChannelCommand	EQU	18Hi8274RstRxCRCCommand	EQU	50Hi8274RstTXCRCCommand	EQU	90Hi8274RstIntrCommand	EQU	010h			;for either ch.i8274RstErrorCommand	EQU	030h			;for either ch.%IF(%i8274NonVectored) THEN (i8274OpieInitCommand	EQU	00010100B		;RTS',non-vectored, 8086 mode,					;  Rx* priority, both interrupt run.) ELSE (i8274OpieInitCommand	EQU	00110100B		;RTS',vectored, 8086 mode,					;  Rx* priority, both interrupt run.) FIi8274VarVect		EQU	04H			;WR1, ch. B: variable vectored interrupts;-----------------------------------------------------------------; Burdock Umbilical Port (i8255); [Programming information on; the Intel '82 Data Component Catalog]i8255portA	EQU	i8255Base+0h	;(R,W)i8255portB	EQU	i8255Base+2h	;(R,W)i8255portC	EQU	i8255Base+4h	;(R,W)i8255ctl	EQU	i8255Base+6h	;(W only) mode instruction, bit set/reset;;-----------------------------------------------------------------; Floppy Disc Controller (i8272); [Programming information on Page 9-146 of; the Intel '82 Data Component Catalog]FDCStatusReg		EQU	i8272Base + 0h		;A1 = 0FDCDataReg		EQU	i8272Base + 2h		;A1 = 1FDCDMADataReg		EQU	i8272Base + 4h		;A2, A1 = 1, 0FDCMotorPort		EQU	WriteCtlReg		;its in the general control register;Timer 1 external clock is connected to FDCFloppyTimerMCWAddr	EQU	i186Timer1MCWAddr	;Timer 1 is used by Floppy.FloppyTimerMaxCountReg	EQU	i186Timer1CountAAddr	;Timer 1 is used by Floppy.FloppyTimerCountReg	EQU	i186Timer1CountRegAddr	;Timer 1 is used by Floppy.FloppyTimerIntCntrlReg	EQU	i186Timer1IntCtlAddr	;Timer 1 is used by Floppy.;Definitions for 186 DMA controller connected to floppy disk:FloppyDMAIntCtlAddr	EQU	i186DMA0IntCtlAddr	;DMA 0 Interrupt Control RegisterFloppyDMALowSourcePtr	EQU	i186DMA0LowSourcePtr	;DMA 0 Low order source pointerFloppyDMAHighSourcePtr	EQU	i186DMA0HighSourcePtr	;DMA 0 High order source pointerFloppyDMALowDestPtr	EQU	i186DMA0LowDestPtr	;DMA 0 Low order destination pointerFloppyDMAHighDestPtr	EQU	i186DMA0HighDestPtr	;DMA 0 High order destination pointerFloppyDMATransferCount	EQU	i186DMA0TransferCount	;DMA 0 transfer countFloppyDMAControlWord	EQU	i186DMA0ControlWord	;DMA 0 control word;ResetFDC		EQU	PCS1Base + 4h		See Above...;ResetFDCnRS232	EQU	PCS1Base + 4h		See Above...;---------------------------------------------------; Ethernet controller equates (i82586); (Fill in later...);---------------------------------------------------;; Processor Interrupt Source types;; Constant EquatesTRUE		EQU	-1hFALSE		EQU	0hZERO		EQU	0h;; System memory sizesOneK		EQU	1024		;Used for calculationsLowRamStart	EQU	0		;Start at Absolute 0LowRamSize	EQU	16*OneK		;16K bytes (16384d=04000h)MidRamStart	EQU	01000h		;Start at Address 010000MidRamSize	EQU	16*OneK		;16K bytes (16384d=04000h)StackSize	EQU	256		;256 bytes (100h)RomStart	EQU	0FC00h		;Start at absolute FFC00hRomSize	EQU	16*OneK		;16K bytes (16384d=04000h)NumOfInterrupts	EQU	256		;256 Interrupt Types;--------------------------------------------; EEProm Definitions:;--------------------------------------------;ETCH ONE/HYBRID Data for WriteConfigReg (from HardDefs);EEPEnable		EQU	8000H;EEPWriteDataMask	EQU	1000H;EEPClk			EQU	0100H;ETCH TWO Data for WriteConfigReg (from HardDefs)EEPEnable		EQU	1000HEEPWriteDataMask	EQU	8000HEEPClk			EQU	2000H;Data for ReadInputReg (from HardDefs)EEPReadDataMask		EQU	0800HEEPStatusReady		EQU	0800H;Command codesEEPCmdRead		EQU	80H	;10aaaaaa, where aaaaaa = word addressEEPCmdWrite		EQU	40H	;01aaaaaaEEPCmdErase		EQU	0C0H	;11aaaaaaEEPCmdEWEnable		EQU	30H	;0011xxxx, where xxxx = don't careEEPCmdEWDisable		EQU	00H	;0000xxxxEEPCmdReset		EQU	20H	;0010xxxx;Word or byte offset constantsbytesInEEProm		EQU	128byteEEPromOffset	EQU	0000HwordEEPromOffset	EQU	0100H;Segment offset constants (high byte must be 00/10/20H shl'ed by 1 for IOPKernl)ROMsegment		EQU	0000HRAMSegment		EQU	2000HbadPageSegment		EQU	4000H; The bit 5 and 6 of machineIDPort and DaisyDisplayTypePort encode the machine type.; These assignments are the following:;;  Bit 6  Bit 5	    Machine  ID;  -----  -----	   -------------;    0      0    Daisy with 19" display;    0      1    Daisy with 15" display;    1      0    Dahlia;    1      1    Daybreak;--------------------------------------------; Daisy Daybreak Distinction:;--------------------------------------------machineIDPort	EQU	0080H		;query here to get a machine ID.machineIDMask	EQU	0040H		;only these 2 bits hold the ID.Daisy		EQU	0000H		;machine ID = this if Daisy.Daybreak	EQU	0040H		;machine ID = this if Daybreak.;--------------------------------------------; Daybreak Dahlia Distinction:;--------------------------------------------machineIDMask2	EQU	0020H		;only these 2 bits hold the ID.Dahlia		EQU	0000H		;machine ID = this if Dahlia.Daybreak2	EQU	0020H		;machine ID = this if Daybreak.;--------------------------------------------; Daisy (only) 15"/19" screen size Distinction:;--------------------------------------------DaisyDisplayTypePort	EQU	0080H	;query here to get display type.DaisyDisplayTypeMask	EQU	0020H	;only this bit holds the type.DaisyfifteenInch	EQU	0020H	;.DaisynineteenInch	EQU	0000H	;.;--------------------------------------------;	End of HardDefs;--------------------------------------------