	include		"Title Screen/Macros.i"

LOGO:
		jsr		ClearScreen
		LoadASCII
		InitTXT	LOGOTXT,18,12
		move.w	#60,	vintTimer.w
	.loop:
		move.b	#4,vintRoutine.w
		bsr.w	VSync
		tst.w	vintTimer.w
		bne.s	.loop
		move.b	#GM_TITLE,	gamemode.w
		rts
		
LOGOTXT:	dc.b	'LOGO'
	LOGOTXT_END:	even