HEXART:		incbin	"Title Screen/HEX.ART"
	HEXEND:	even

SNDTEST:
		jsr		ClearScreen
		LVLDMA	HEXART,$4000,HEXEND-HEXART,VRAM
		InitTXT	STTXT,STTXT_END,15,12
		move.b	#$80,	SelNum
		bsr.s	.print
	.loop:
		move.b	#4,vintRoutine.w
		bsr.w	VSync
		btst	#bR,(p1CtrlTap).w	;	right
		bne.w	.up
		btst	#bL,(p1CtrlTap).w	;	left
		bne.w	.down
		btst	#bSt,(p1CtrlTap).w	;	start
		bne.w	.exit
		move.b	(p1CtrlTap).w,	d0	;	ABC
		and.b	#bitA+bitB+bitC,	d0
		bne.s	.play
		bra.s	.loop
		
	.exit:
		rts
		
	.up:
		add.b	#1,	SelNum
		bsr.s	.print
		bra.s	.loop
	.down:
		sub.b	#1,	SelNum
		bsr.s	.print
		bra.s	.loop
	.play:
		move.b	SelNum,	d0
		jsr		PlayFMSound
		bra.s	.loop
		
	.print:
		moveq	#0,	d0
		move.b	SelNum,	d0
		and.b	#$F0,	d0
		ror.b	#4,		d0
		add.w	#$200,	d0
		move.l	#$40000003+(19*$20000)+(16*$800000),(VDPCTRL)
		move.w	d0,	VDPDATA
		moveq	#0,	d0
		move.b	SelNum,	d0
		and.b	#$0F,	d0
		add.w	#$200,	d0
		move.l	#$40000003+(20*$20000)+(16*$800000),(VDPCTRL)
		move.w	d0,	VDPDATA
		rts
		
STTXT:	dc.b	'SOUND TEST'
	STTXT_END:	even