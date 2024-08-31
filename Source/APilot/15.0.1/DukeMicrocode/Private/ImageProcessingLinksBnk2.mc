{File name:  ImageProcessingLinksBnk2.mcDescription: Dispatches and imported labels for image processing opcodesAuthor: JPMCreated: August 18, 1987Last Revised:12-Sep-88 19:13:02 -- JSxO/TxH --  moved to bank2; changed the file name;October 8, 1987 -- JPM -- change reserve areas to allow overwriting of BandBLT entry pointsNovember 13, 1987 -- JPM -- remove reserves (for unsegmented code)}{ 	Copyright (C) 1987 by Xerox Corporation.  All rights reserved.}	Bank2ESCDisp[A];	{-- Image Processing Instructions (A0H - AFH are reserved) }	{@FLOYD:		in Floyd			c1, at[ 0,10,ESCAn];}	{@GRAYBLT:		in GrayBLTCtrl			c1, at[ 1,10,ESCAn];}	{@GRAYSUM:		in GrayBLTCtrl			c1, at[ 2,10,ESCAn];}	{@GRAYTHRSHLD:		in GrayBLTCtrl			c1, at[ 3,10,ESCAn];}	{@TRAPZBLT:		in TrapzInit			c1, at[ 4,10,ESCAn];}	{@COUNTBITSON:		in CountBits			c1, at[ 5,10,ESCAn];}	{@COUNTBITSOFF:		in CountBits			c1, at[ 6,10,ESCAn];}	{@BLTLINEGRAY:		in BLTLineGray			c1, at[ 7,10,ESCAn];}	{@HALFTONE:		in Halftone			c1, at[ 8,10,ESCAn];}	{@CHAINBLT:		in ChainBLT			c1, at[ 9,10,ESCAn];}	{@BUMPBITADDRESS:	in BumpBitAddress		c1, at[0A,10,ESCAn];}	{@FLIPXBITS:		in FlipX			c1, at[0B,10,ESCAn];}	{@FLIPXGRAY:		in FlipX			c1, at[0C,10,ESCAn];}	{@ROTATEBITS:		in Rotate			c1, at[0D,10,ESCAn];}	{@LINEBREAK:		in LineBreak			c1, at[0E,10,ESCAn];}	{@SCALEBITSTOGRAY:	in ScaleBits			c1, at[0F,10,ESCAn];}