	NAME	MFCBlocks$       TITLE(MFCBlocks)$	NOLIST			$	INCLUDE(MOONLINK.def)$	LIST		MonitorCode	SEGMENT  COMMON;-----------------------------------------------------------------; Monitor File Control Block          ORG 	ExtMFCBlockLoc;TestN	DB  0;FileNumberBias	DB  0B5H;TestNE	DB  7;TestNS	DB  0;TestSizeConf	DB  11;FileType	DB  8;ConfigInfo	DB  1;FCBSpare0	DB  0;TCBPointer	DW  ExtTCBlock;EndingTestNum0 	DB  7;StartingTestNum0 	DB  0;EndingTestNum1 	DB  7;StartingTestNum1 	DB  0;EndingTestNum2 	DB  7;StartingTestNum2 	DB  0;EndingTestNum3 	DB  7;StartingTestNum3 	DB  0;EndingTestNum4 	DB  7;StartingTestNum4 	DB  0;EndingTestNum5 	DB  7;StartingTestNum5 	DB  0;EndingTestNum6 	DB  7;StartingTestNum6 	DB  0;EndingTestNum7 	DB  7;StartingTestNum7 	DB  0;EndingTestNum8 	DB  7;StartingTestNum8 	DB  0;EndingTestNum9 	DB  7;StartingTestNum9 	DB  0;EndingTestNum10 	DB  7;StartingTestNum10 	DB  0;EndingTestNum11 	DB  7;StartingTestNum11 	DB  0;EndingTestNum12 	DB  7;StartingTestNum12 	DB  0;EndingTestNum13 	DB  7;StartingTestNum14 	DB  0;EndingTestNum14 	DB  7;StartingTestNum14 	DB  0;EndingTestNum15 	DB  7;StartingTestNum15 	DB  0MonitorCode	ENDS		END 