REM Display.bat (Daybreak)REM Copyright (C) 1987 by Xerox Corporation. All rights reserved.BREAK ONREM ----------------------REM Build Display.lnk!REM ----------------------XFILE RET DsplDefs.asm -oXFILE RET IOPDefs.asm -oXFILE RET HardDefs.asm -oXFILE RET DsplHdlr.asm -oXFILE RET STKDisp.asm -oXFILE RET IORDisp.asm -oCRLFTool /lf DsplDefs.asmDEL DsplDefs.bakCRLFTool /lf IOPDefs.asmDEL IOPDefs.bakCRLFTool /lf HardDefs.asmDEL HardDefs.bakCRLFTool /lf DsplHdlr.asmDEL DsplHdlr.bakCRLFTool /lf STKDisp.asmDEL STKDisp.bakCRLFTool /lf IORDisp.asmDEL IORDisp.bakRUN ASM86 DsplHdlr.asm DEBUG > DsplHdlr.logRUN ASM86 STKDisp.asm DEBUG > STKDisp.logRUN ASM86 IORDisp.asm DEBUG > IORDisp.logTYPE DsplHdlr.logTYPE STKDisp.logTYPE IORDisp.logPAUSERUN LINK86 DsplHdlr.obj,IORDisp.obj,STKDisp.obj to Display.lnkXFILE STORE IORDisp.obj -oXFILE STORE DsplHdlr.obj -oXFILE STORE STKDisp.obj -oXFILE STORE Display.lnk -oXFILE STORE Display.mp1 -oREM ROMRAMSys.bat (Daybreak) depends on components rebuilt in here!REM fini