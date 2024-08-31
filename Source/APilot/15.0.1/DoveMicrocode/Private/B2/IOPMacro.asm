;Copyright (C) 1984, 1985 by Xerox Corporation. All rights reserved.;-- stored as [Idun]<WDLion>Dove>IOPMacro.asm;-- created on  14-Feb-84 11:13:22;;-- last edited by:;;--	KEK	11-Aug-86 16:57:43	:changes for multiple options support;--	KEK	 1 Aug 85 18:37:33	:Changed ReadEEProm macro.;--	JPM	22-Jul-85 13:46:58	:Changed order of loading parameters in NotifyClientCondition (load BX last since might be used in address specification).;--	JPM	18-Jul-85  9:34:57	:Changed SetupOpieAddressInCXDX to use struc fields.;--	JPM	16-Jul-85  9:25:16	:Added WORD PTR to client condition MOVs.;--	JPM	28-Jun-85 13:07:01	:Separated SystemCalls into ROM and RAM portions (RAM empty for now).;--	JPM	25-Jun-85 17:33:54	:Changed macros which use interruptName (no EXTRNs).;--	JPM	24-Jun-85  9:13:53	:Changed ReadEEProm.;--	JPM	18-Jun-85 13:15:01	:Add GetIntervalTimer; use SI for all taskPtr parms.;--	JPM	24-May-85 13:40:15	:Remove alternate locking from MesaLockedOut macro;--	JPM	15-May-85 13:52:31	:Opie redesign;--	kEK    	 2-Mar-85 19:07:10	:add interruptTimeout;--	kEK	19-Feb-85 14:49:37	:Add PUSH/POP ES to WaitForMumble. cleaned up code format;--	VXS	26-Nov-84 16:19:25	:Fix bug in ClientCondition (include code inside generateEScall);--	VXS	20-Nov-84 22:17:23	:add conditionTimeout definition.;--	VXS	15-Nov-84 13:50:25	:Add ControlRegister macro.;--	VXS	 5-Nov-84 18:04:31	:add RegisterPCEStartRoutine, CallPCEStartRoutine;--	VXS	 5-Nov-84 17:59:29	:Add SI-DI arg to restart for runtime determination of restart address;--	VXS	15-Oct-84 10:19:33	:Install Reset macro;--	VXS	12-Oct-84 18:32:25	:Install Restart macro;--	VXS	10-Oct-84 18:36:41	:Changed Reset macro to do a software interrupt instead of inline code.;--	VXS	 3-Oct-84 11:35:44	:Fix confusion on SetupOpieAddressInCXDX macro;--	VXS	28-Sep-84 18:11:40	:Put delay test cx,[bx] instruction in MesaLockedOut macro;--	VXS	20-Sep-84 19:50:58	:Fix NotifyClientCondition macro bugs;--	VXS	19-Sep-84 17:30:01	:Add EstablishIOPAccess;--	VXS	17-Sep-84 16:52:02	:Change NotifyClientcondition to use LEA instead of macro;--	VXS	31-Aug-84 15:37:59	:Use a macro to generate System call instructions, and so can use it in IOPData.asm.;--	VXS	31-Aug-84 15:28:58	:Added NotifyClientcondition macro, INT;--	VXS	28-Aug-84 12:06:40	:Changed arg to SubInterrupt to be just interrupt name rather than interruptType;--	VXS	27-Aug-84 17:48:59	:Added new SubInterrupt macro definition;--	JPM	20-Aug-84 16:15:31	:Took spaces out of MesaLockedOut string compares;--	VXS	21-Aug-84 18:01:35	:Added MinimumStackSize defintiion;--	VXS	16-Aug-84 12:36:59	:Change Initialize Task for private stacks.;--	VXS	 6-Aug-84 17:38:28	:Changed SoftwareInterruptBase to Type;--	JPM	 6-Jul-84 11:20:29	:Removed MesaLockedOutMemToMem.;--	JPM	 3-Jul-84 13:57:45	:Added ReadEEProm.;--	FXB	 2-Jul-84 14:25:36	:added BindweedIntr Codemacro		;--	JPM	 2-Jul-84 13:57:56	:Added MesaLockedOutMemToMem.;--	JMM	27-Jun-84 15:17:44	:Compatible with Opie Version 1 release.;--	ETN	26-Jun-84 15:20:54	:InitializeTask change.;--	ETN	21-Jun-84 18:33:54	:Restored EstablishIOPAccess.;--	JMM/ETN	21-Jun-84 18:33:54	:Deleted Converts, etc.;--	JMM	10-Jun-84 17:14:13	:Version 1 release.;			IOPMacro;--------------------------------------------------------------------------------;IMPORTED VARIABLES:;Generate INT Instructions using two data bytesInterruptCode			EQU	0CDH;The following must match the equivalent definition in HardOpie.asm. If it doesn't, an error will be generated by the linker.%IF (%NES(%softwareIntrptVctType,Defined))     THEN (     PUBLIC	softwareIntrptVctType     softwareIntrptVctType	EQU	96     )FI;--------------------------------------------------------------------------------;;System Macros:%*DEFINE		(SystemCalls)			   (			    %SET(n,0)			    %*DEFINE(whereDefined)(ROM)			    %SystemCall(CallPCEStartRoutine)			    %SystemCall(ControlRegister)			    %SystemCall(ConvertAddress)			    %SystemCall(Disable)			    %SystemCall(Enable)			    %SystemCall(EstablishHandlerAccess)			    %SystemCall(EstablishIOPAccess)			    %SystemCall(GetIntervalTimer)			    %SystemCall(GetLockMask)			    %SystemCall(GetWorkMask)			    %SystemCall(InitializeTask)			    %SystemCall(Jam)			    %SystemCall(MesaLockedOut)			    %SystemCall(NotifyClientCondition)			    %SystemCall(NotifyCondition)			    %SystemCall(NotifyHandlerCondition)			    %SystemCall(ReadEEProm)			    %SystemCall(RegisterPCEStartRoutine)			    %SystemCall(Reset)			    %SystemCall(Restart)			    %SystemCall(ThisTaskServices)			    %SystemCall(WaitForCondition)			    %SystemCall(WaitForInterrupt)			    %SystemCall(WaitForSystem)			    %SystemCall(WaitForTime)			    %*DEFINE(whereDefined)(RAM)			    %SystemCall(GetOptionsInterrupt)			    %SystemCall(ReleaseDMAChannel)			    %SystemCall(WaitForDMAChannel)				)%*DEFINE		(SystemCall (Name))			   (			    %Name%(SIVType)	EQU	softwareIntrptVctType+%n			    %SET(n,%EVAL(%n+1))				)	%SystemCalls;--------------------------------------------------------------------------------;Lower level support macros:;Macro to setup CX-DX with an Opie address if the argument isn't CX-DX%*DEFINE		(SetupOpieAddressInCXDX (OpieAddressEA))			   (			    %IF (%NES(%OpieAddressEA,CX-DX))			         THEN (				 MOV	CX,%OpieAddressEA.OpieAddressHigh				 MOV	DX,%OpieAddressEA.OpieAddressLow				 )FI				);--------------------------------------------------------------------------------;User called Macros:%*DEFINE		(CallPCEStartRoutine)			   (			    DB	InterruptCode, LOW CallPCEStartRoutineSIVType				)%*DEFINE		(ControlRegister (mask, value))			   (			    %IF (%NES (%mask,CX))			         THEN (MOV	CX, %mask				 )FI			    %IF (%NES (%value,AX))			         THEN (MOV	AX, %value			         )FI			    DB	InterruptCode, LOW ControlRegisterSIVType				)%*DEFINE		(ConvertAddress (OpieAddressEA))  			   ( 			    %SetupOpieAddressInCXDX(%OpieAddressEA)			    DB	InterruptCode, LOW ConvertAddressSIVType				)%*DEFINE		(Disable (interruptName))  			   (			    %IF	(%NES (%interruptName,BX))				 THEN (MOV  BX, %interruptName				 )FI			    DB	InterruptCode, LOW DisableSIVType				)%*DEFINE		(DisableInterruptsTillNextWait)  			   (			    CLI				)%*DEFINE		(Enable	(interruptName))  			   (			    %IF	(%NES (%interruptName,BX))				 THEN (MOV  BX, %interruptName				 )FI			    DB	InterruptCode, LOW EnableSIVType				)%*DEFINE		(EstablishHandlerAccess (handlerID))  			   (			    %IF	(%NES (%handlerID,AX))				 THEN (MOV	AX, %handlerID				 )FI 			    DB	InterruptCode, LOW EstablishHandlerAccessSIVType				)%*DEFINE		(EstablishIOPAccess (MapNo,OpieAddressEA))  			   (			    %IF	(%NES (%MapNo,AX))				 THEN (MOV	AX, %MapNo				 )FI 			    %SetupOpieAddressInCXDX(%OpieAddressEA)			    DB	InterruptCode, LOW EstablishIOPAccessSIVType				)%*DEFINE		(GetLockMask)   			   (			    DB	InterruptCode, LOW GetLockMaskSIVType				)%*DEFINE		(GetIntervalTimer)   			   (			    DB	InterruptCode, LOW GetIntervalTimerSIVType				)%*DEFINE		(GetWorkMaskForCondition	(conditionPtr))   			   (			    %IF	(%NES (%conditionPtr,BX))				 THEN (MOV	BX, %conditionPtr				 )FI				    DB	InterruptCode, LOW GetWorkMaskSIVType				)%*DEFINE		(InitializeTask	(handlerID, taskPtr, initLoc, initialStackPtr))  			   (			    %IF	(%NES (%handlerID,AX))				 THEN (MOV	AX, %handlerID				 )FI			    %IF	(%NES (%taskPtr,SI))				 THEN (MOV	SI, %taskPtr				 )FI			    %IF (%NES (%initLoc,CX-DX))			    	 THEN (				 MOV	CX, OFFSET %initLoc				 MOV	DX, CS			         )FI			    %IF	(%NES (%initialStackPtr,DI))				 THEN (MOV	DI, %initialStackPtr				 )FI			    DB	InterruptCode, LOW InitializeTaskSIVType				)%*DEFINE		(Jam	(handlerID, taskPtr))  			   (			    %IF	(%NES (%handlerID,AX))				 THEN (MOV	AX, %handlerID				 )FI			    %IF	(%NES (%taskPtr,SI))				 THEN (MOV	SI, %taskPtr				 )FI			    DB	InterruptCode, LOW JamSIVType				)%*DEFINE		(MesaLockedOut	(operation, dataPtr, dataRegOrVal, lockMask)) 			   ( 			    %IF	(%NES (%dataRegOrVal,AX))				 THEN (MOV	AX, %dataRegOrVal				 )FI			    %IF	(%NES (%dataPtr,BX))				 THEN (MOV	BX, %dataPtr				 )FI			    %IF	(%NES (%lockMask,CX))				 THEN (MOV	CX, %lockMask				 )FI			    %IF	(%EQS (%operation,ADD))				 THEN (MOV	DX, 0				 )ELSE				    (				     %IF (%EQS (%operation,AND))				          THEN (MOV	DX, 1					  )ELSE					     (					      %IF (%EQS (%operation,OR))				                   THEN (MOV	DX, 2						   )ELSE 						      (						       %IF (%EQS (%operation,XCHG))				      			    THEN (MOV	DX, 3							    )ELSE (MOV	DX, 4							    )FI	       				                   )FI						          )FI				 )FI			    DB		InterruptCode, LOW MesaLockedOutSIVType				)%*DEFINE		(NotifyClientCondition (clientCondition))		   	   (		   	    %IF (%NES (%clientCondition,AX-BX-CX))			         THEN (				 MOV	AX, WORD PTR %clientCondition				 MOV	CX, WORD PTR %clientCondition[4]				 MOV	BX, WORD PTR %clientCondition[2]				 )FI			    DB InterruptCode, LOW NotifyClientConditionSIVType				)%*DEFINE		(NotifyCondition (conditionPtr))			   (			    %IF	(%NES (%conditionPtr,BX))				 THEN (MOV	BX, %conditionPtr				 )FI			    DB	InterruptCode, LOW NotifyConditionSIVType				)%*DEFINE		(NotifyHandlerCondition (handlerID, conditionPtr))			   (			    %IF	(%NES (%handlerID,AX))				 THEN (MOV	AX, %handlerID				 )FI			    %IF	(%NES (%conditionPtr,BX))				 THEN (MOV	BX, %conditionPtr				 )FI			    DB	InterruptCode, LOW NotifyHandlerConditionSIVType				)%*DEFINE		(ReadEEProm (eePromAddress, eePromVersion))			   (			    %IF	(%NES (%eePromVersion,AX))				 THEN (MOV	AX, %eePromVersion				 )FI			    %IF	(%NES (%eePromAddress,BX))			    	 THEN (MOV	BX, %eePromAddress				 )FI			    DB	InterruptCode, LOW ReadEEPromSIVType				)%*DEFINE		(RegisterPCEStartRoutine	(location))			   (			    %IF (%NES (%location,CX-DX))			         THEN (			  	 MOV	CX, OFFSET %location				 MOV	DX, CS			         )FI			    DB	InterruptCode, LOW RegisterPCEStartRoutineSIVType				)%*DEFINE		(Reset	(deviceResetMask))			   (			    %IF	(%NES (%deviceResetMask,AX))		    		 THEN (MOV	AX, %deviceResetMask				 )FI			    DB	InterruptCode, LOW ResetSIVType				)%*DEFINE		(Restart	(handlerID, taskPtr, initLoc, initialStackPtr))  			   (			    %IF	(%NES (%handlerID,AX))				 THEN (MOV	AX, %handlerID				 )FI			    %IF	(%NES (%taskPtr,SI))				 THEN (MOV	SI, %taskPtr				 )FI			    %IF (%NES (%initLoc,CX-DX))			    	 THEN (				 MOV	CX, OFFSET %initLoc				 MOV	DX, CS			         )FI			    %IF	(%NES (%initialStackPtr,DI))				 THEN (MOV	DI, %initialStackPtr				 )FI			    DB	InterruptCode, LOW RestartSIVType				)%*DEFINE		(SubInterrupt (interruptName))			   (			    DB InterruptCode, LOW %interruptName				)%*DEFINE 		(ThisTaskServices (interruptName, badInterruptProcLoc))			   (			    %IF	(%NES (%interruptName,BX))				 THEN (MOV  BX, %interruptName				 )FI			    %IF (%NES (%badInterruptProcLoc,CX-DX))			    	 THEN (				 MOV	CX, OFFSET %badInterruptProcLoc				 MOV	DX, CS			         )FI			    DB	InterruptCode, LOW ThisTaskServicesSIVType				)%*DEFINE		(WaitForCondition	(conditionParms))			   (			    %MATCH	(conditionPtr,timeoutInterval)	(%conditionParms)			    %IF	(%EQS (%timeoutInterval,noTimeout) OR %EQS (%timeoutInterval,%()))						THEN (XOR	AX, AX				)ELSE 				   (				    %IF (%NES (%timeoutInterval,AX))				         THEN (MOV	AX, %timeoutInterval					 )FI				)FI			    %IF	(%NES (%conditionPtr,BX))				THEN (MOV	BX, %conditionPtr				)FI			    DB	InterruptCode, LOW WaitForConditionSIVType				)			   %*DEFINE		(WaitForInterrupt	(timeoutInterval))  			   (			    %IF	(%EQS (%timeoutInterval,noTimeout) OR %EQS (%timeoutInterval,%()))						THEN (XOR	AX, AX				)ELSE 				   (				    %IF (%NES (%timeoutInterval,AX))				         THEN (MOV	AX, %timeoutInterval					 )FI				)FI			    DB	InterruptCode, LOW WaitForInterruptSIVType				)			   %*DEFINE		(WaitForSystem)				   (			    DB	InterruptCode, LOW WaitForSystemSIVType				)			   %*DEFINE		(WaitForTime	(interval))			   (			    %IF	(%NES (%interval,AX))			        THEN (MOV	AX, %interval				)FI			    DB	InterruptCode, LOW WaitForTimeSIVType				)								;The following are defined in RAM:												%*DEFINE		(GetOptionsInterrupt(interruptMask, handlerInterruptNumber))			   (		 	    %IF (%NES (%interruptMask,DX))			        THEN (MOV	DX, %interruptMask			        )FI		            %IF (%NES (%handlerInterruptNumber,CX))			        THEN (MOV	CX, %handlerInterruptNumber			        )FI			    DB	InterruptCode, LOW GetOptionsInterruptSIVType			        )				%*DEFINE		(ReleaseDMAChannel)  			   (			    DB	InterruptCode, LOW ReleaseDMAChannelSIVType				)				%*DEFINE		(WaitForDMAChannel)  			   (			    DB	InterruptCode, LOW WaitForDMAChannelSIVType				);------------------------------------------------------------------------------