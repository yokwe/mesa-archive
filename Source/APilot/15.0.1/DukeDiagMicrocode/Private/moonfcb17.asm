	NAME	FCBlock$       TITLE(FCBlock)$	NOLIST			$	INCLUDE(MOONLINK.def)$	INCLUDE(MOONSYS.def)$	LIST		MonitorCode	SEGMENT  COMMON;-----------------------------------------------------------------; Monitor File Control Block          ORG 	ExtMFCBlockLoc;TestN	DB  00;FileNumberBias	DB  1Bh;TestNE	DB  1;TestNS	DB  0;TestSizeConf	DB  23;FileType	DB  0AH;ConfigInfo	DB  0;FCBSpare0	DB  0;TCBPointer	DW  ExtTCBlock;EndingTestNum0		;S 0, Default, Non-Destructive	DB  1;StartingTestNum0 	DB  0;EndingTestNum1	DB  0;StartingTestNum1 	DB  0;EndingTestNum2			DB  0;StartingTestNum2 	DB  0;EndingTestNum3			DB  0;StartingTestNum3 	DB  0;EndingTestNum4	DB  6;StartingTestNum4 	DB  5;EndingTestNum5	DB  7;StartingTestNum5 	DB  7;EndingTestNum6	DB  1;StartingTestNum6 	DB  0;EndingTestNum7	DB  1;StartingTestNum7 	DB  0;EndingTestNum8		DB  1;StartingTestNum8 	DB  0;EndingTestNum9		DB  1;StartingTestNum9 	DB  0;EndingTestNum10 	DB  1;StartingTestNum10 	DB  0;EndingTestNum11 	DB  1;StartingTestNum11 	DB  0;EndingTestNum12 	DB  1;StartingTestNum12 	DB  0;EndingTestNum13 	DB  1;StartingTestNum14 	DB  0;EndingTestNum14 	DB  3;StartingTestNum14 ;S E, short destructive	DB  2;EndingTestNum15 ;S F, long destructive	DB  4;StartingTestNum15 	DB  4MonitorCode	ENDS		END 