$ ASM86 Sirius.asm debug$ LINK86 Sirius.obj  TO  Sirius.lnk$ loc86 Sirius.lnk to Sirius.lm addresses -(segments(SiriusSeg(1400H)))