$MOD186$PAGELENGTH (72)$PAGEWIDTH  (136);Copyright (C) 1986 by Xerox Corporation. All rights reserved.;-- STKPPO.asm defines stacks used by the ParallelPort Option (PPO)  handler.;-- stored as [BamBam:Osbu North]<WMicro>Dove>STKPPO.ASM;-- created on    3-Jul-86 15:28:12;;-- last edited by:;--	JMA		  5-Dec-86 15:01:32	:;==========================  STACK  PPO  ================================; STKPPO.asm - contains the stack allocation for each task in PPO handlerNAME			STKPPO;==========================  INCLUDES  DECLARATIONS  ======================$NOLIST$INCLUDE		(IOPStack.asm)$LIST;==========================  PPO STACK SEGMENT  ==========================PPOSTK			SEGMENT		COMMON 			%StackAllocation	(PPOMainStack,)			%StackAllocation	(PPOIntrpStack,)			%StackAllocation	(PPOInServiceStack,)PPOSTK			ENDS;********************************************************************************			END