SelNum	=	$FFFF0000

ASCII:	incbin		"Title Screen/ASCII.ART"
ASCII_END:	even

TITLE:
		jsr		ClearScreen
		LoadASCII
		InitTXT	TITLETXT1,TITLETXT1_END,2,1
		InitTXT	TITLETXT2,TITLETXT2_END,1,2
		InitTXT	TITLETXT3,TITLETXT3_END,1,3
		InitTXT	TITLETXT4,TITLETXT4_END,2,4
		InitTXT	TITLETXT5,TITLETXT5_END,4,5
		InitTXT	TITLETXT6,TITLETXT6_END,1,6
		InitTXT	TITLETXT7,TITLETXT7_END,2,7
		
		InitTXT	TITLETXT2_1,TITLETXT2_1_END,27,9
		InitTXT	TITLETXT2_2,TITLETXT2_2_END,27,10
		InitTXT	TITLETXT2_3,TITLETXT2_3_END,27,11
		InitTXT	TITLETXT2_4,TITLETXT2_4_END,27,12
		InitTXT	TITLETXT2_5,TITLETXT2_5_END,27,13
		InitTXT	TITLETXT2_6,TITLETXT2_6_END,27,14
		InitTXT	TITLETXT2_7,TITLETXT2_7_END,27,15
		
		InitTXT	TITLETXT3_1,TITLETXT3_1_END,1,25
		InitTXT	TITLETXT3_2,TITLETXT3_2_END,1,26
		InitTXT	TITLETXT3_3,TITLETXT3_3_END,26,26
		
		InitTXT	TITLESEL1,TITLESEL1_END,6,16
		InitTXT	TITLESEL2,TITLESEL2_END,6,18
		InitTXT	TITLESEL3,TITLESEL3_END,6,20
		InitTXT	TITLESEL4,TITLESEL4_END,6,22
		
		move.b	#0,	SelNum
	.loop:
		move.b	#4,vintRoutine.w
		bsr.w	VSync
		
		move.w	#$3E,	d2
		bsr.w	DisplayCurs
		
	;	process selection
		btst	#bUp,(p1CtrlTap).w
		bne.w	.up
		btst	#bDn,(p1CtrlTap).w
		bne.w	.down
		btst	#bSt,(p1CtrlTap).w
		bne.w	ProcessSel
		bra.w	.loop
		
	.up:
		move.w	#0,	d2
		bsr.w	DisplayCurs
		sub.b	#1,	SelNum
		cmpi.b	#$FF,	SelNum
		bne.w	.loop
		move.b	#3,	SelNum
		bra.w	.loop
	.down:
		move.w	#0,	d2
		bsr.w	DisplayCurs
		add.b	#1,	SelNum
		cmpi.b	#4,	SelNum
		bne.w	.loop
		move.b	#0,	SelNum
		bra.w	.loop
		
ProcessSel:
		move.b	SelNum,	d0
		rol.b	#1,	d0
		move.w	.index(pc,d0.w),d0
		jmp		.index(pc,d0.w)
	.index:
		dc.w	.opt1-.index
		dc.w	.opt2-.index
		dc.w	.opt3-.index
		dc.w	.opt4-.index

	.opt1:
		move.b	#GM_LEVEL,	gamemode.w
		rts
	.opt2:
	.opt4:
		rts
	.opt3:
		bra.w	SNDTEST
		
DisplayCurs:
		move.l	#$40000003+(4*$20000)+(16*$800000),	d0 ; initial offset of cursor (x4 y16)
		move.b	SelNum,	d1
	.loopsel:
		tst.b	d1
		beq.s	.cont
		add.l	#$1000000,	d0
		sub.b	#1,	d1
		bra.s	.loopsel
	.cont:
		move.l	d0,	VDPCTRL
		move.w	d2,	VDPDATA	;	tile to draw
		rts
	
	
	DefTXT TITLETXT1, "###   ###  ##  # ##  ###"
	DefTXT TITLETXT2,'## ## ## ## ### # ## ## ##'
	DefTXT TITLETXT3,'##    ## ## ##### ## ##'
	DefTXT TITLETXT4, '###  ## ## ## ## ## ##'
	DefTXT TITLETXT5,   '## ## ## ##  # ## ##'
	DefTXT TITLETXT6,'## ## ## ## ##  # ## ## ##'
	DefTXT TITLETXT7, '###   ###  ##  # ##  ###'
	
	DefTXT TITLETXT2_1,'##   # ####'
	DefTXT TITLETXT2_2,'### ## ## ##'
	DefTXT TITLETXT2_3,'###### ## ##'
	DefTXT TITLETXT2_4,'## # # ## ##'
	DefTXT TITLETXT2_5,'##   # ## ##'
	DefTXT TITLETXT2_6,'##   # ## ##'
	DefTXT TITLETXT2_7,'##   # ####'
	
	DefTXT TITLETXT3_1,'ROM DATE'
TITLETXT3_2: incbin	time.temp
	TITLETXT3_2_END:
	DefTXT TITLETXT3_3, 'MDTRAVIS 2025'
	
	DefTXT TITLESEL1,	"START GAME"
	DefTXT TITLESEL2,	"OPTIONS"
	DefTXT TITLESEL3,	"SOUND TEST"
	DefTXT TITLESEL4,	"STAGE SELECT"
	
	include		"Title Screen/SoundTest.asm"