$! -- stored as [Iris]<WMicro>Dove>Disk.com;$! -- created on 15-Aug-85 14:53:36$!$! -- last edited by:$!$! --    KEK          15-Aug-85 14:53:31 ; created$!$! -- Opie files needed: IOPDefs HardOpie IOPMacro$!$! -- Files needed: UmbDefs.asm PreBindw.asm Bindweed.asm PreBootF.asm$!$! -- Files produced: Preboot.lnk Preboot.mp1$!$ASM86 PreBindw.asm  DEBUG > PreBindw.log$ASM86 Bindweed.asm  DEBUG > Bindweed.log$ASM86 PrebootF.asm DEBUG > PrebootF.log$!$LINK86 PrebootF.obj, PreBindw.obj, Bindweed.obj TO Preboot.lnk$!