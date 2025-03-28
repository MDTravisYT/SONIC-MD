WARP:
		jsr		ClearScreen
		LoadASCII
		InitTXT	WARPTXT,18,12
		move.w	#60,	vintTimer.w
		move.w	#$8700+%00000000,(VDPCTRL)      ;	BACKGROUND COLOR
		move.w	#0,	palette+4
	.loop:
		move.b	#4,vintRoutine.w
		jsr		VSync
		tst.w	vintTimer.w
		bne.s	.loop
		move.b	#GM_LEVEL,	gamemode.w
		rts
		
WARPTXT:	dc.b	'WARP'
	WARPTXT_END:	even