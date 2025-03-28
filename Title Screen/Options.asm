OPTIONS:
		jsr		ClearScreen
		clr.b	SelNum
		InitTXT	OPSTR_OP1,10,10
		InitTXT	OPSTR_OP2,10,12
		InitTXT	OPSTR_OP3,10,14
		InitTXT	OPSTR_OP4,10,16
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
		btst	#bSt,(p1CtrlTap).w	;	start
		bne.w	.exit
		bsr.w	.displayOP4
		CursorInit	$3E,8,10
		bra.s	.loop
	.exit:
		rts
	.up:
		CursorInit	0,8,10
		sub.b	#1,	SelNum
		cmpi.b	#$FF,	SelNum
		bne.w	.loop
		move.b	#3,	SelNum
		bra.w	.loop
	.down:
		CursorInit	0,8,10
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
		dc.w	.DOP1-.Selindex
		dc.w	.DOP2-.Selindex
		dc.w	.DOP3-.Selindex
		dc.w	.DOP4-.Selindex
	.DOP1:
		lea		0,	a0
		move.b	#3,	d0 ; cap
		rts
	.DOP2:
		lea		0,	a0
		move.b	#1,	d0 ; cap
		rts
	.DOP3:
		lea		0,	a0
		move.b	#3,	d0 ; cap
		rts
	.DOP4:
		lea		debugCheat,	a0
		move.b	#1,	d0 ; cap
		rts
		
	.displayOP4:
		moveq	#0,	d0
		move.b	debugCheat,	d0	;	TIME print
		rol.b	#1,	d0
		move.w	.index(pc,d0.w),d0
		jmp		.index(pc,d0.w)
		
	.index:
		dc.w	.OP4_1-.index
		dc.w	.OP4_2-.index
		
	.OP4_1:
		lea		OP4_1,	a0
		move.l	#(OP4_1_END-OP4_1)-1,	d0
		bra.s	.OP4_cont
	.OP4_2:
		lea		OP4_2,	a0
		move.l	#(OP4_2_END-OP4_2)-1,	d0
	;	bra.s	.dispTime
		
	.OP4_cont:
		lea		VDPDATA,a1
		move.l	#$40000003+(24*$20000)+(16*$800000),(VDPCTRL)
		moveq	#0,	d1
		jmp		loadASCII2

	DefTXT	OPSTR_OP1,	"SOUNDTRACK"
	DefTXT	OPSTR_OP2,	"SPINDASH"
	DefTXT	OPSTR_OP3,	"SOUND EFFECTS"
	DefTXT	OPSTR_OP4,	"EDIT MODE"

	DefTXT	OP1_1,	"(MD) JP/PAL"
	DefTXT	OP1_2,	"(MD) US"
	DefTXT	OP1_3,	"(CD) MODE 1"
	DefTXT	OP1_4,	"OFF"

	DefTXT	OP2_1,	"CD STYLE"
	DefTXT	OP2_2,	"MD STYLE"
	
	DefTXT	OP3_1,	"SONIC CD"
	DefTXT	OP3_2,	"CD-SONIC"
	DefTXT	OP3_3,	"MEGA DRIVE"
	DefTXT	OP3_4,	"OFF"
	
	DefTXT	OP4_1,	"OFF"
	DefTXT	OP4_2,	"ON "