	NAME	MoonPSOTCB$	TITLE(PSOTCBlocks)$	NOLIST$	INCLUDE(MOONSYS.def)			$	INCLUDE(MOONLINK.def)$	LIST		MonitorCode	SEGMENT  COMMON;-----------------------------------------------------------------; Monitor Test Control Block          ORG 	ExtTCBlockLoc	 ;TESTnumber0-----------------------------------------------------;ErrorLoop			DB	00H	;TESType			DB	03H	;Maintain mode in Byte ;PageParity			DB 00H			;BankParity		DB 00H				;WORDPattern			DW	4241H	;ASCII of BA;NUMBERofPass						DB	0ffH;LASTpass			DB	00H;PORTstatus			DW	0000H;PSOstatus			DB	00H;PSOFault			DB	00H	;Information on PSO fault		;TESTnumber1-----------------------------------------------------;ErrorLoop			DB	00H	;TESType			DB	04H	;Maintain mode in word;PageParity			DB 00H			;BankParity		DB 00H			;WORDPattern			DW	4241H	;ASCII of BA;NUMBERofPass						DB	0ffH;LASTpass			DB	00H;PORTstatus			DW	0000H;PSOstatus			DB	00H;PSOFault			DB	00H	;Information on PSO fault			 ;TESTnumber2-----------------------------------------------------	 ;ErrorLoop			DB	00H	;TESType			DB	00H	;Word DMA transfer;PageParity			DB 00H			;BankParity		DB 00H			;WORDPattern			DW	00H	;ASCII of AB;NUMBERofPass				DB	01H	;20 Block of data;LASTpass			DB	00H;PORTstatus			DW	0000H;PSOstatus			DB	00H;PSOFault			DB	00H	;Information on PSO fault		;TESTnumber3-----------------------------------------------------;ErrorLoop			DB	00H	;TESType			DB	01H	;Byte DMA transfer;PageParity			DB 00H			;BankParity		DB 00H			;WORDPattern			DW	00H	;ASCII of AB;NUMBERofPass				DB	01H	;20 Block of data;LASTpass			DB	00H;PORTstatus			DW	0000H;PSOstatus			DB	00H;PSOFault			DB	00H	;Information on PSO fault		;TESTnumber4-----------------------------------------------------;ErrorLoop			DB	00H	;TESType			DB	02H	;Prom Error Interrupt;PageParity			DB 00H			;BankParity		DB 00H			;WORDPattern			DW	00H	;ASCII of AB;NUMBERofPass				DB	02H	;ff times;LASTpass			DB	00H;PORTstatus			DW	0000H;PSOstatus			DB	00H;PSOFault			DB	00H	;Information on PSO fault										MonitorCode	ENDS		END 