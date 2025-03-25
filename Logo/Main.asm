ASCII:	incbin		"Title Screen/ASCII.ART"
ASCII_END:	even

LoadASCII	macro
		LVLDMA		ASCII,$0400,ASCII_END-ASCII,VRAM
		move.l		#$EEE,	palette
		endm
		
InitTXT	macro	src,end,x,y
	lea		src,	a0
	lea		VDPDATA,a1
	move.l	#(end-src)-1,	d0
	move.l	#$40000003+(x*$20000)+(y*$800000),(VDPCTRL)
	moveq	#0,	d1
	jsr		loadASCII2
	endm

LOGO:
		jsr		ClearScreen
		LoadASCII
		InitTXT	LOGOTXT,LOGOTXT_END,18,12
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