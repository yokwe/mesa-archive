REM MPHandlr.bat (Daybreak)REM Copyright (C) 1987 by Xerox Corporation. All rights reserved.BREAK ONREM ----------------------REM Build MPHandlr.lnk!REM ----------------------XFILE RET IOPStack.asm -oXFILE RET IOPDefs.asm -oXFILE RET HardDefs.asm -oXFILE RET IOPMacro.asm -oXFILE RET IORMaint.asm -oXFILE RET MPHandlr.asm -oXFILE RET STKMaint.asm -oCRLFTool /lf IOPStack.asmDEL IOPStack.bakCRLFTool /lf IOPDefs.asmDEL IOPDefs.bakCRLFTool /lf HardDefs.asmDEL HardDefs.bakCRLFTool /lf IOPMacro.asmDEL IOPMacro.bakCRLFTool /lf IORMaint.asmDEL IORMaint.bakCRLFTool /lf MPHandlr.asmDEL MPHandlr.bakCRLFTool /lf STKMaint.asmDEL STKMaint.bakRUN ASM86 IORMaint.asm DEBUG > IORMaint.logRUN ASM86 MPHandlr.asm DEBUG > MPHandlr.logRUN ASM86 STKMaint.asm DEBUG > STKMaint.logTYPE IORMaint.logTYPE MPHandlr.logTYPE STKMaint.logPAUSERUN LINK86 MPHandlr.obj,IORMaint.obj,STKMaint.obj to MPHandlr.lnkXFILE STORE IORMaint.obj -oXFILE STORE MPHandlr.obj -oXFILE STORE STKMaint.obj -oXFILE STORE MPHandlr.lnk -oXFILE STORE MPHandlr.mp1 -oREM ROMRAMSys.bat (Daybreak) depends on components rebuilt in here!REM fini