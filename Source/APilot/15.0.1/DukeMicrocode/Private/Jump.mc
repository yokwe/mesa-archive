{File name:  Jump.mc Description: PrincOps version 3.0 Jump microcode for Dandelion, Author: RXG (Based on Wildflower microcode by RxL), Created: April 10, 1979, AHL/JPM, 5-Jan-87 9:05:31,  Fixed bug in JSa, JSb (BRANCH not masked fully), JPM, 10-Oct-84 13:03:41,  Rewrote code for updated PC (see Refill.mc), DEG,  1-Sep-84 19:37:59,  Add copyright notice, AXD, 21-Jun-83 15:52:52,  Implement JD*, AXD, 15-Jun-83 17:37:52,  New Instruction Set, JGS, November 9, 1981  8:10 AM,  New Instruction Set, Last Edited: RXG, April 11, 1980  6:56 PM, Last Edited: RXJ, August 27, 1980  4:49 PM} { 	Copyright (C) 1980, 1981, 1983, 1984 by Xerox Corporation.  All rights reserved.}{6. Jump Instructions}{Jn	Jump n = 2-8JB	Jump ByteJW	Jump WordCATCH	CatchJEP	Jump Equal PairJEB	Jump Equal ByteJEBB	Jump Equal Byte ByteJNEP	Jump Not Equal PairJNEB	Jump Not Equal ByteJNEBB	Jump Not Equal Byte ByteJZn	Jump Zero n = 3-4JZB	Jump Zero ByteJNZn	Jump Not Zero n = 3-4JNZB	Jump Not Zero ByteJDEB	Jump Double Equal ByteJDNEB	Jump Double Not Equal ByteJLB	Jump Less ByteJLEB	Jump Less Equal ByteJGB	Jump Greater ByteJGEB	Jump Greater Equal ByteJULB	Jump Unsigned Less ByteJULEB	Jump Unsigned Less Equal ByteJUGB	Jump Unsigned Greater ByteJUGEB	Jump Unsigned Greater Equal ByteJIB	Jump Indexed ByteJIW	Jump Indexed WordJS	Jump Stack}{Note: Update of the Map flag bits (which occurs first time page is touched) adds 2 clicks to the pagecross times given below}{*****************************************************************************Overview:	The jump code is written assuming the jump will be taken and a page boundary will not be crossed.  It also assumes the PC (in particular, the real page part) is correct unless uPCCross is true (see comments at Refill microcode).	The jump instructions increment the PC before testing for any page faults.  If the page we're jumping to is mapped out, then, after the page fault  trap, we should execute the byte code we're jumping to instead of restarting the Jump instruction.Register Useage:	L2[0-1]	number of pops required 0 => 0; 1,2 => 1; 3 => 2	L2[0,2]	PC increment	L2[3]	0	L2 should be examined at the PageFault location (if L0=JRemap) to determine how to fixup the stack pointer.	Note that the PC increment field is not used for Jn, JB, &JW since they always jump.  *****************************************************************************}{L2 codes used to indicate stackP and PC fixups}	Set[L2.Pop0IncrX, 0  {00xx}]; {will be 2 with Jn cross}	{Jn, JB, JW}	Set[L2.Pop1Incr1, 4  {0100}];	{JZn, JNZn}	Set[L2.Pop1Incr2, 6  {0110}];	{JZB, JNZB, JEP, JNEP}	Set[L2.Pop1Incr3, 0A  {1010}];	{JEBB, JNEBB}	Set[L2.Pop2Incr2, 0C  {1100}];	{JEB,JNEB,J(/U)(L/LE/G/GE)B}	Set[L2.Pop2Incr3, 0E  {1110}];	{JIB, JIW}{6.1 Unconditional Jumps}{****************************************************************************	CATCH****************************************************************************}@CATCH:	MAR � PC � [rhPC, PC+1], push, GOTO[JnPos],		c1, opcode[200'b];{*****************************************************************************	Jn, n=2-8*****************************************************************************}@J2:	MAR � PC � [rhPC, PC+1], push, GOTO[JnPos],		c1,opcode[201'b];@J3:	MAR � PC � [rhPC, PC+1+PC16], push, GOTO[JnPos],	c1,opcode[202'b];@J4:	MAR � PC � [rhPC, PC+2], push, GOTO[JnPos],		c1,opcode[203'b];@J5:	MAR � PC � [rhPC, PC+2+PC16], push, GOTO[JnPos],	c1,opcode[204'b];@J6:	MAR � PC � [rhPC, PC+3], push, GOTO[JnPos],		c1,opcode[205'b];@J7:	MAR � PC � [rhPC, PC+3+PC16], push, GOTO[JnPos],	c1,opcode[206'b];@J8:	MAR � PC � [rhPC, PC+4], push, GOTO[JnPos],		c1,opcode[207'b];{*****************************************************************************	JB*****************************************************************************}@JB:	L2 � L2.Pop0IncrX,					c1,opcode[210'b];jb:	T � ib RShift1, XLDisp, GOTO[jT],				c2;{*****************************************************************************	JW*****************************************************************************}@JW:	T � ib, XLDisp, L2 � L2.Pop0IncrX,			c1,opcode[211'b];jw:	T � T LRot8, push, BRANCH[jwPos, jwNeg, 1],			c2;jwPos:	T � RShift1 (T or ib), SE�0, XLDisp, GOTO[jwtos],		c3;jwNeg:	T � RShift1 (T or ib), SE�1, XLDisp, GOTO[jwtos],		c3;jwtos:	PC � PC and 0FF, BRANCH[jwEven, jwOdd, 2],			c1;jwEven:	Q � PC + T, GOTO[jwCross],					c2;jwOdd:	Q � PC + T + PC16, GOTO[jwCross],				c2;jwCross:	STK � TOS,							c3;		Xbus � uPCCross, XRefBr,					c1;	PC � Q, BRANCH[$, jwCrossPCCross],				c2;	L0 � L0.JRemap, GOTO[UpdatePC], 				c3;jwCrossPCCross:	Q � Q - r0100, L0 � L0.JRemap, GOTO[UpdatePC], 			c3;{*****************************************************************************	JDEB*****************************************************************************}@JDEB:	T � STK, pop,						c1,opcode[236'b];	[] � STK xor TOS, ZeroBr,					c2;	TOS � STK, pop, BRANCH[JDEBa, JDEBb],				c3;	JDEBa:	Xbus � 1, XLDisp, L2 � L2.Pop2Incr2, GOTO[jc22],		c1;JDEBb:	[] � STK xor T, NZeroBr, L2 � L2.Pop2Incr2, GOTO[jc22],		c1;{*****************************************************************************	JDNEB*****************************************************************************}@JDNEB:	T � STK, pop,						c1,opcode[237'b];	[] � STK xor TOS, NZeroBr,					c2;	TOS � STK, pop, BRANCH[JDNEBa, JDNEBb],				c3;	JDNEBa:	Xbus � 1, XLDisp, L2 � L2.Pop2Incr2, GOTO[jc22],		c1;JDNEBb:	[] � STK xor T, ZeroBr, L2 � L2.Pop2Incr2, GOTO[jc22],		c1;{*****************************************************************************	JEP*****************************************************************************}@JEP:	[] � alpha.left xor TOS, NZeroBr, L2 � L2.Pop1Incr2,	c1,opcode[212'b];jp:	T � alpha.right RShift1, XLDisp, BRANCH[jpT, jpF],		c2;jpF:	L2Disp, push, Xbus � ib, CANCELBR[NoJump, 3],			c3;jpT:	T � T + 2, BRANCH[jpEven, jpOdd, 2],				c3;jpEven:	MAR � PC � [rhPC, PC + T], push, Xbus � ib, GOTO[JPos],		c1;jpOdd:	MAR � PC � [rhPC, PC + T + PC16], push, Xbus � ib, GOTO[JPos],	c1;{*****************************************************************************	JEB*****************************************************************************}@JEB:	[] � STK xor TOS, NZeroBr, L2 � L2.Pop2Incr2,		c1,opcode[213'b];jc22:	T � ib RShift1, XLDisp, BRANCH[jT, jF],				c2;{*****************************************************************************	JEBB*****************************************************************************}@JEBB:	[] � ib xor TOS, NZeroBr, L2 � L2.Pop1Incr3,		c1,opcode[214'b];jc13:	T � ib RShift1, XLDisp, BRANCH[jT, jF],				c2;{*****************************************************************************	JNEP*****************************************************************************}@JNEP:	[] � alpha.left xor TOS, ZeroBr, L2 � L2.Pop1Incr2, GOTO[jp],	c1, opcode[215'b];{*****************************************************************************	JNEB*****************************************************************************}@JNEB:	[] � STK xor TOS, ZeroBr, L2 � L2.Pop2Incr2, GOTO[jc22],	c1, opcode[216'b];{*****************************************************************************	JNEBB*****************************************************************************}@JNEBB:	[] � ib xor TOS, ZeroBr, L2 � L2.Pop1Incr3, GOTO[jc13],	c1,opcode[217'b];{*****************************************************************************	JZn, n = 3-4*****************************************************************************}@JZ3:	[] � TOS, NZeroBr, L2 � L2.Pop1Incr1,			c1,opcode[230'b];jz3:	T � 3 RShift1, XLDisp, BRANCH[jT, jF],				c2;@JZ4:	[] � TOS, NZeroBr, L2 � L2.Pop1Incr1,			c1,opcode[231'b];jz4:	T � 4 RShift1, XLDisp, BRANCH[jT, jF],				c2;{*****************************************************************************	JZB*****************************************************************************}@JZB:	[] � TOS, NZeroBr, L2 � L2.Pop1Incr2,			c1,opcode[232'b];jc12:	T � ib RShift1, XLDisp, BRANCH[jT, jF],				c2;{*****************************************************************************	JNZn, n = 3-4*****************************************************************************}@JNZ3:	[] � TOS, ZeroBr, L2 � L2.Pop1Incr1, GOTO[jz3],		c1,opcode[233'b];@JNZ4:	[] � TOS, ZeroBr, L2 � L2.Pop1Incr1, GOTO[jz4],		c1,opcode[234'b];{*****************************************************************************	JNZB*****************************************************************************}@JNZB:	[] � TOS, ZeroBr, L2 � L2.Pop1Incr2, GOTO[jc12],	c1,opcode[235'b];{*****************************************************************************	JLB*****************************************************************************}{Jump if j<k :  j-k is neg & no overflow OR j-k is pos & overflow}@JLB:	T � STK {T�j},						c1,opcode[220'b];	T � T - TOS {T�j-k}, PgCrOvDisp, GOTO[Jg],			c2;{*****************************************************************************	JGB*****************************************************************************}{Jump if j>k :  k-j is neg & no overflow OR k-j is pos & overflow}@JGB:	T � STK {T�j},						c1,opcode[222'b];	T � TOS - T {T�k-j}, PgCrOvDisp,				c2;Jg:	T � ~T, BRANCH[jNoOv, jOv, 2],					c3;{*****************************************************************************	JGEB*****************************************************************************}{Jump if j>=k :  j-k is pos & no overflow OR j-k is neg & overflow}@JGEB:	T � STK {T�j},						c1,opcode[221'b];	T � T - TOS {T�j-k}, PgCrOvDisp, GOTO[Jle],			c2;{*****************************************************************************	JLEB*****************************************************************************}{Jump if j<=k :  k-j is pos & no overflow OR k-j is neg & overflow}@JLEB:	T � STK {T�j},						c1,opcode[223'b];	T � TOS - T {T�k-j}, PgCrOvDisp,				c2;Jle:	BRANCH[jNoOv, jOv, 2],						c3;jNoOv:	[] � T, NegBr, L2 � L2.Pop2Incr2, GOTO[jc22],			c1;jOv:	[] � ~T, NegBr, L2 � L2.Pop2Incr2, GOTO[jc22],			c1;{The Unsigned jumps place Carry into the sign bit and share the signed jump code}{*****************************************************************************	JULB*****************************************************************************}{Jump if u<v :  no carry from u-v}@JULB:	T � STK,						c1,opcode[224'b];	T � DARShift1 (T - TOS), GOTO[Jle],				c2;{*****************************************************************************	JUGB*****************************************************************************}{Jump if v>u :  no carry from v-u}@JUGB:	T � STK,						c1,opcode[226'b];	T � DARShift1 (TOS - T), GOTO[Jle],				c2;{*****************************************************************************	JUGEB*****************************************************************************}{Jump if u>=v :  carry from u-v}@JUGEB:	T � STK,						c1,opcode[225'b];	T � DARShift1 (T - TOS), GOTO[Jg],				c2;{*****************************************************************************	JULEB*****************************************************************************}{Jump if u<=v :  carry from v-u}@JULEB:	T � STK,						c1,opcode[227'b];	T � DARShift1 (TOS - T), GOTO[Jg],				c2;{*****************************************************************************	JIB*****************************************************************************}	Set[L2.JIB, 0];	Set[L2.JIW, 4];@JIB:	T � STK{index}, L2 � L2.JIB,				c1,opcode[240'b];	TT � RShift1 T{index/2}, GOTO[jiCom],				c2;{*****************************************************************************	JIW*****************************************************************************}@JIW:	T � STK{index}, L2 � L2.JIW,				c1,opcode[241'b];	TT � T{index}, GOTO[jiCom],					c2;jiCom:	[] � T - TOS {index-limit}, CarryBr,				c3;	T � ib, BRANCH[$, jiNoJump],					c1;	T � T LRot8, L0�L0.JI,						c2;	T � T or ib {base}, L1�L1.None,					c3;	T � T + TT,							c1;	Q � UvC{code base},						c2;	rhTT � UvChigh,							c3;{Set the ibPtr to empty}	Map � Q � [rhTT, Q + T], IBPtr�1,				c1;	Xbus � ib,							c2;	Rx � rhRx � MD, XRefBr,						c3;jiRedo:	MAR � [rhRx, Q+0], BRANCH[jiMapUD, $],			c1, RLMFRet[L0.JI];	Xbus � STK, XLDisp, L2Disp,					c2;	IB � MD {ibFront�disp}, DISP3[jibL, 2],			c3;jibL:	T � 0, L2�L2.Pop2Incr3, GOTO[ji],			c1, at[2,8,jibL];jibR:	T � 0, Xbus � ib, L2�L2.Pop2Incr3, GOTO[ji],		c1, at[3,8,jibL];jiwL:	T � ib, XLDisp, L2�L2.Pop2Incr3, GOTO[ji],		c1, at[6,8,jibL];jiwR:	T � ib, XLDisp, L2�L2.Pop2Incr3, GOTO[ji],		c1, at[7,8,jibL];ji:	T � T LRot8, push, BRANCH[jwPos, jwNeg, 1],			c2;jiMapUD:	CALL[RLMapFix] {will return to jiRedo},				c2;jiNoJump:	Xbus � ib, PC � PC+PC16,					c2;	Xbus � L2.Pop2Incr3, XDisp, push, GOTO[NoJump],			c3;{*****************************************************************************	JS	Jump Stack in Xfer*****************************************************************************}@JS:	TT � UvC, XC2npcDisp, push,					c1, at[9,10,ESC1n];	PC � TOS RShift1, IBPtr�1, Xbus�STK, XDisp, BRANCH[JSa,JSb,0E],	c2;JSa:	Q � PC, Cin�pc16, BRANCH[JSc, JSd, 0E],				c3;JSb:	Q � PC, BRANCH[JSc, JSd, 0E],					c3;JSc:	TT � TT and ~0FF, GOTO[JSe],					c1;JSd:	TT � TT and ~0FF, Cin�pc16, GOTO[JSe],				c1;JSe:	UvPCpage � TT, L2�L2.Pop0IncrX, GOTO[jwCross],			c2;{*****************************************************************************	jump common code*****************************************************************************}{The abscence of a pending branch at jT causes a jump and the prescence causes the jump to be aborted.  T contains the word offset and TT the word offset for backwards jumps + 1.}jT:	TT � 7F - T, push, DISP2[JPosEven],				c3;jF:	L2Disp, push {point to u}, CANCELBR[NoJump, 3],			c3;{Fetch the first destination word, check for a page crossing, and prepare to save TOS into STK.}JPosEven:	MAR � PC � [rhPC, PC + T], GOTO[JPos],			c1, at[0,4,JPosEven];JPosOdd:	MAR � PC � [rhPC, PC + T + PC16], GOTO[JPos],		c1, at[1,4,JPosEven];JNegEven:	MAR � PC � [rhPC, PC - TT - 1], Xbus � uPCCross, XRefBr, GOTO[JNeg],	c1, at[2,4,JPosEven];JNegOdd:	MAR � PC � [rhPC, PC - TT - 1], Cin�pc16, Xbus � uPCCross, XRefBr, GOTO[JNeg],	c1, at[3,4,JPosEven];{Dispatch on the stackP fixup (L2[0-1]) and the new value of pc16.  Also save TOS into STK.  Place the first destination word into IB, or in the case of a page cross, prepare to remap the PC as in a "Buffer Empty" refill. (see Refill.mc).  If the jump doesn't page fault, reset uPCCross.}JPos:	STK � TOS, Xbus�0, L2Disp, XC2npcDisp, BRANCH[jPNoCross, jP1Cross, 1],	c2;JNeg:	STK � TOS, Xbus�0, L2Disp, XC2npcDisp, DISP2[jNNoCross],	c2;JnPos:	STK � TOS, L2 � L2.Pop0IncrX, Xbus�0, XC2npcDisp, DISP2[jnPNoCross],	c2;jnPNoCross:	IB � MD, pop, DISP4[JPtr1Pop0, 2],			c3, at[0,4,jnPNoCross];jPNoCross:	IB � MD, pop, DISP4[JPtr1Pop0, 2],			c3;jNNoCross:	IB � MD, pop, DISP4[JPtr1Pop0, 2],			c3, at[0,4,jNNoCross];{No negative page cross, but uPCCross is true. Don't load the IB, set Q to compensate for the page cross, and go to UpdatePC.}jNNoCrossPC:	Q � - r0100, L0 � L0.JRemap, CANCELBR[UpdatePC, 0F],	c3, at[1,4,jNNoCross];{A page cross ocurred on the first destination word: goto the Refill page cross code.  If a page fault occurs L2 encodes the required stack pointer fixup.The high half of Q contains the page displacement.  The low half of PC points to the word of the destination page.  pc16 is correct.  Note that for all the jump "byte" instructions and Jn the page displacement in Q is either +1 or -1.  For JW, Q is arbitrary.  (See Refill.mc.)Control for no Map update will go: UpdatePCx (in Refill.mc), JCross (in Refill.mc), JRedo, JPtr1Pop0....}jnP1Cross:	Q � r0100, Xbus � uPCCross, XRefBr, L0 � L0.JRemap, CANCELBR[UpdatePC, 0F],	c3, at[2,4,jnPNoCross];jP1Cross:	Q � r0100, Xbus � uPCCross, XRefBr, L0 � L0.JRemap, CANCELBR[UpdatePC, 0F],	c3;jN1Cross:	Q � - r0100, L0 � L0.JRemap, CANCELBR[UpdatePC,0F], c3, at[2,4,jNNoCross];jN1CrossPC:	{This can't happen. Take out after debugging.}	Q � - r0100, L0 � L0.JRemap, CANCELBR[UpdatePC,0F], c3, at[3,4,jNNoCross];{Fetch the second destination word, set the instruction buffer pointer, and prepare to load TOS.  If a PageCross occurs, treat it like the "Buffer Not Empty" refill case.The Stack fixup code assumes that TOS has been saved into TOS for jumps which have no stack arguments (Jn, JB, JW).Note that the Stack at JPtr1Pop0 (etc..) should be identical to the Stack at entry to the particular Jump instruction, execpt TOS has been saved into STK.  When control reaches RCross or NoRCross (in Refill.mc) the stack appears as if the jump instruction has finished.  If there is a page fault (via RCross), there will be no stack fixup.}JPtr1Pop0:	MAR � [rhPC, PC + 1], IBPtr�1, push, GOTO[Jgo],	c1, at[2,10,JPtr1Pop0];JPtr1Pop1:	MAR � [rhPC, PC + 1], IBPtr�1, GOTO[Jgo],	c1, at[6,10,JPtr1Pop0];JPtr1Pop1x:	MAR � [rhPC, PC + 1], IBPtr�1, GOTO[Jgo],	c1, at[0A,10,JPtr1Pop0];JPtr1Pop2:	MAR � [rhPC, PC + 1], IBPtr�1, pop, GOTO[Jgo],	c1, at[0E,10,JPtr1Pop0];JPtr0Pop0:	MAR � [rhPC, PC + 1], IBPtr�0, push, GOTO[Jgo],	c1, at[3,10,JPtr1Pop0];JPtr0Pop1:	MAR � [rhPC, PC + 1], IBPtr�0, GOTO[Jgo],	c1, at[7,10,JPtr1Pop0];JPtr0Pop1x:	MAR � [rhPC, PC + 1], IBPtr�0, GOTO[Jgo],	c1, at[0B,10,JPtr1Pop0];JPtr0Pop2:	MAR � [rhPC, PC + 1], IBPtr�0, pop, GOTO[Jgo],	c1, at[0F,10,JPtr1Pop0];Jgo:	TOS � STK, AlwaysIBDisp, L0 � L0.NERefill.Set, DISP2[NoRCross],	c2;{Don't jump: Save TOS into STK and increment the PC and prepare to load TOS according to the Jump instruction which is encoded in L2.  Note that Jn, JB, or JW do not come through NoJump since they always jump.}NoJump:	STK � TOS, pop, DISP4[jPop1Incr1, 1],				c1;jPop1Incr1:	PC � PC+PC16, IBDisp, GOTO[SLa],		c2, at[5,10,jPop1Incr1];jPop1Incr2:	PC � PC+1, IBDisp, GOTO[SLa],			c2, at[7,10,jPop1Incr1];jPop1Incr3:	PC � PC+1+PC16, IBDisp, GOTO[SLa],		c2, at[0B,10,jPop1Incr1];jPop2Incr2:	PC � PC+1, IBDisp, pop, GOTO[SLa],		c2, at[0D,10,jPop1Incr1];jPop2Incr3:	PC � PC+1{+PC16 at jiNoJump}, IBDisp, pop, GOTO[SLa],	c2, at[0F,10,jPop1Incr1];