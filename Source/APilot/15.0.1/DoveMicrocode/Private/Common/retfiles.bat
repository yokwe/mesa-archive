REM RetFiles.batREM Copyright (C) 1987 by Xerox Corporation. All rights reserved.BREAK ONREM ----------------------REM Fetch PCE stuff!REM ----------------------REM Common filesXFILE RET PCEDEFS.asm -oREM Dispatcher filesXFILE RET IORPDspt.asm -oXFILE RET STKPDspt.asm -oXFILE RET PCDsptch.asm -oXFILE RET PCEHBUFF.asm -oREM Display filesXFILE RET DISPLDEF.asm -oXFILE RET IORPDSPY.asm -oXFILE RET STKPDSPY.asm -oXFILE RET PCDISPLY.asm -oREM Printer filesXFILE RET PrntDefs.asm -oXFILE RET IORPPRNT.asm -oXFILE RET STKPPRNT.asm -oXFILE RET PCPRINTR.asm -oREM Floppy filesXFILE RET IORPFlop.asm -oXFILE RET STKPFlop.asm -oXFILE RET PFloppy.asm -oXFILE RET FlopFace.asm -oREM DMA filesXFILE RET IORPDMA.asm -oXFILE RET PDMAEML.asm -oREM Serial filesXFILE RET IORPSRIL.asm -oXFILE RET STKPSRIL.asm -oXFILE RET PCSERIAL.asm -oREM Opie FilesXFILE RET IOPDefs.asm -oXFILE RET IOPMacro.asm -oXFILE RET HardDefs.asm -oXFILE RET IOPStack.asm -oXFILE RET QueDefs.asm -oXFILE RET QueMacro.asm -oXFILE RET OpieDefs.asm -oXFILE RET ROMEEP.asm -oXFILE RET ROMBDefs.asm -oREM RAM Handlers FilesXFILE RET RAMHands.asm -oXFILE RET RAMHInit.asm -oCRLFTool /lf PCEDEFS.asmDEL PCEDEFS.bakCRLFTool /lf IORPDspt.asmDEL IORPDspt.bakCRLFTool /lf STKPDspt.asmDEL STKPDspt.bakCRLFTool /lf PCDsptch.asmDEL PCDsptch.bakCRLFTool /lf PCEHBUFF.asmDEL PCEHBUFF.bakCRLFTool /lf DISPLDEF.asmDEL DISPLDEF.bakCRLFTool /lf IORPDSPY.asmDEL IORPDSPY.bakCRLFTool /lf STKPDSPY.asmDEL STKPDSPY.bakCRLFTool /lf PCDISPLY.asmDEL PCDISPLY.bakCRLFTool /lf PrntDefs.asmDEL PrntDefs.bakCRLFTool /lf IORPPRNT.asmDEL IORPPRNT.bakCRLFTool /lf STKPPRNT.asmDEL STKPPRNT.bakCRLFTool /lf PCPRINTR.asmDEL PCPRINTR.bakCRLFTool /lf IORPFlop.asmDEL IORPFlop.bakCRLFTool /lf STKPFlop.asmDEL STKPFlop.bakCRLFTool /lf PFloppy.asmDEL PFloppy.bakCRLFTool /lf FlopFace.asmDEL FlopFace.bakCRLFTool /lf IORPDMA.asmDEL IORPDMA.bakCRLFTool /lf PDMAEML.asmDEL PDMAEML.bakCRLFTool /lf IORPSRIL.asmDEL IORPSRIL.bakCRLFTool /lf STKPSRIL.asmDEL STKPSRIL.bakCRLFTool /lf PCSERIAL.asmDEL PCSERIAL.bakCRLFTool /lf IOPDefs.asmDEL IOPDefs.bakCRLFTool /lf IOPMacro.asmDEL IOPMacro.bakCRLFTool /lf HardDefs.asmDEL HardDefs.bakCRLFTool /lf IOPStack.asmDEL IOPStack.bakCRLFTool /lf QueDefs.asmDEL QueDefs.bakCRLFTool /lf QueMacro.asmDEL QueMacro.bakCRLFTool /lf OpieDefs.asmDEL OpieDefs.bakCRLFTool /lf ROMEEP.asmDEL ROMEEP.bakCRLFTool /lf ROMBDefs.asmDEL ROMBDefs.bakCRLFTool /lf RAMHands.asmDEL RAMHands.bakCRLFTool /lf RAMHInit.asmDEL RAMHInit.bakXFILE RET AsmPCE.bat -oCRLFTool /lf AsmPCE.batDEL AsmPCE.bakAsmPCE.batREM AsmPCE.bat depends on components fetched in here!REM fini