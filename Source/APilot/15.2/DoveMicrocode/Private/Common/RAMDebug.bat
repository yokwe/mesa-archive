REM RAMDebug.batREM Copyright (C) 1987 by Xerox Corporation. All rights reserved.BREAK ONREM ----------------------REM Build RAMDebug/RAMDbgE/MemDebug.loc!REM ----------------------REM Daisy Debugging locate addresses:REM       floppy RAM: 13B0H   Mem: locator calc'sREM       e'net RAM:  1450H   Mem: locator calc'sREM       disk RAM:   13B0H   Mem: locator calc'sREM [RAM addresses come from the CS that you read afterREM   single stepping past the StartRAM label in initial.]REM [Mem addresses come from the location of theREM   IOREnd segment in the MemLoad.mp2 file.]xfile ret RAMDbLc.bat -oxfile ret RAMDbLcE.bat -oxfile ret MemDbLoc.bat -oCRLFTool /lf RAMDbLc.batDEL RAMDbLc.bakCRLFTool /lf RAMDbLcE.batDEL RAMDbLcE.bakCRLFTool /lf MemDbLoc.batDEL MemDbLoc.bakRUN LOC86 RAMLoad.lnk TO RAMDebug.loc & < RAMDbLc.batRUN LOC86 RAMLoad.lnk TO RAMDbgE.loc & < RAMDbLcE.batRUN LOC86 MemLoad.lnk TO MemDebug.loc & < MemDbLoc.batXFILE store RAMDebug.loc -oXFILE store RAMDbgE.loc -oXFILE store MemDebug.loc -oREM fini