StageSelect:
		jsr		ClearScreen
		clr.b	SelNum
		LVLDMA	HEXART,$4000,HEXEND-HEXART,VRAM
		InitTXT	SS_STR1,15,10
		InitTXT	SS_STR2,15,12
		InitTXT	SS_STR3,15,14
		InitTXT	SS_STR4,15,16
		InitTXT	SS_STR5,1,26
		bsr.w	.display
		CursorInit	$3E,13,10
	.loop:
		move.b	#4,vintRoutine.w
		bsr.w	VSync
		btst	#bUp,(p1CtrlTap).w	;	up
		bne.w	.up
		btst	#bDn,(p1CtrlTap).w	;	down
		bne.w	.down
		btst	#bL,(p1CtrlTap).w	;	left
		bne.w	.left
		btst	#bR,(p1CtrlTap).w	;	right
		bne.w	.right
		btst	#bB,(p1CtrlTap).w	;	B
		bne.w	.exit
		btst	#bSt,(p1CtrlTap).w	;	start
		bne.w	.start
		bsr.w	.display
		CursorInit	$3E,13,10
		bra.s	.loop
	.exit:
		rts
	.start:
		move.b	#GM_LEVEL,	gamemode.w
		rts
	.up:
		CursorInit	0,13,10
		sub.b	#1,	SelNum
		cmpi.b	#$FF,	SelNum
		bne.w	.loop
		move.b	#3,	SelNum
		bra.w	.loop
	.down:
		CursorInit	0,13,10
		add.b	#1,	SelNum
		cmpi.b	#4,	SelNum
		bne.w	.loop
		move.b	#0,	SelNum
		bra.w	.loop
	.right:
		bsr.w	.getSel
		add.b	#1,	(a0)
		add.b	#1,	d0
		move.b	(a0),	d1
		cmp.b	d1,	d0
		bne.w	.loop
		move.b	#0,	(a0)
		bra.w	.loop
	.left:
		bsr.w	.getSel
		sub.b	#1,	(a0)
		cmpi.b	#-1,	(a0)
		bne.w	.loop
		move.b	d0,	(a0)
		bra.w	.loop
		
	.getSel:
		move.b	SelNum,	d0
		rol.b	#1,	d0
		move.w	.Selindex(pc,d0.w),d0
		jmp		.Selindex(pc,d0.w)
	.Selindex:
		dc.w	.ROUND-.Selindex
		dc.w	.ZONE-.Selindex
		dc.w	.TIME-.Selindex
		dc.w	.GOOD-.Selindex
	.ROUND:
		lea		zone,	a0
		move.b	#6,	d0 ; cap
		rts
	.ZONE:
		lea		act,	a0
		move.b	#2,	d0 ; cap
		rts
	.TIME:
		lea		timeZone,	a0
		move.b	#2,	d0 ; cap
		rts
	.GOOD:
		lea		goodFuture,	a0
		move.b	#1,	d0 ; cap
		rts
		
	.display:
		moveq	#0,	d0	;	ROUND print
		move.b	zone,	d0
		and.b	#$0F,	d0
		add.w	#$201,	d0
		move.l	#$40000003+(21*$20000)+(10*$800000),(VDPCTRL)
		move.w	d0,	VDPDATA
		
		moveq	#0,	d0	;	ZONE print
		move.b	act,	d0
		and.b	#$0F,	d0
		add.w	#$201,	d0
		move.l	#$40000003+(21*$20000)+(12*$800000),(VDPCTRL)
		move.w	d0,	VDPDATA
		
		moveq	#0,	d0	;	GOOD print
		move.b	goodFuture,	d0
		and.b	#$0F,	d0
		add.w	#$200,	d0
		move.l	#$40000003+(21*$20000)+(16*$800000),(VDPCTRL)
		move.w	d0,	VDPDATA
		
		moveq	#0,	d0
		move.b	timeZone,	d0	;	TIME print
		rol.b	#1,	d0
		move.w	.index(pc,d0.w),d0
		jmp		.index(pc,d0.w)
		
	.index:
		dc.w	.past-.index
		dc.w	.present-.index
		dc.w	.future-.index
		
	.past:
		lea		SS_STR3_1,	a0
		move.l	#(SS_STR3_1_END-SS_STR3_1)-1,	d0
		bra.s	.dispTime
	.present:
		lea		SS_STR3_2,	a0
		move.l	#(SS_STR3_2_END-SS_STR3_2)-1,	d0
		bra.s	.dispTime
	.future:
		lea		SS_STR3_3,	a0
		move.l	#(SS_STR3_3_END-SS_STR3_3)-1,	d0
	;	bra.s	.dispTime
		
	.dispTime:
		lea		VDPDATA,a1
		move.l	#$40000003+(21*$20000)+(14*$800000),(VDPCTRL)
		moveq	#0,	d1
		jmp		loadASCII2

	DefTXT	SS_STR1,	"ROUND"	;	zone
	DefTXT	SS_STR2,	"ZONE"	;	act
	DefTXT	SS_STR3,	"TIME"	;	timeZone
	DefTXT	SS_STR4,	"GOOD"	;	goodFuture
	DefTXT	SS_STR3_1,	"PAST   "
	DefTXT	SS_STR3_2,	"PRESENT"
	DefTXT	SS_STR3_3,	"FUTURE "
	DefTXT	SS_STR5,	"PRESS B TO EXIT"