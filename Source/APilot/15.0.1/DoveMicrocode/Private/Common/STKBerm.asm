$MOD186$PAGELENGTH (72)$PAGEWIDTH  (136);Copyright (C) 1985 by Xerox Corporation. All rights reserved.;-- STKBerm.asm defines stacks used by the bootstrap handler.;-- stored as [Iris]<WMicro>Dove>STKBerm.asm;-- created on  18-Sep-85 17:56:07;;-- last edited by:;--	JAC/RDH		19-Feb-86 15:07:14	:Change size to min.;--	JAC		27-Sep-85 16:38:18	:Created.NAME			STKBerm;--------------------------------------------------------------------------------$NOLIST$INCLUDE		(IOPStack.asm)$LIST;********************************************************************************CPBermudaSTK		SEGMENT		COMMON 			%StackAllocation	(CPBermudaStack,MinimumStackSize)CPBermudaSTK		ENDS;********************************************************************************			END