TITLE:
		jsr		ClearScreen
		LoadASCII
		InitTXT	TITLETXT,TITLETXT_END,18,12
		move.w	#60,	vintTimer.w
	.loop:
		move.b	#4,vintRoutine.w
		bsr.w	VSync
		tst.w	vintTimer.w
		bne.s	.loop
		move.b	#GM_LEVEL,	gamemode.w
		rts
		
TITLETXT:	dc.b	'TITLE'
	TITLETXT_END:	even