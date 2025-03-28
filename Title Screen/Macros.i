LoadASCII	macro
		LVLDMA		ASCII,$0400,ASCII_END-ASCII,VRAM
		move.l		#$EEE,	palette
		endm
		
InitTXT	macro	src,x,y
		lea		src,	a0
		lea		VDPDATA,a1
		move.l	#(\src\_end-src)-1,	d0
		move.l	#$40000003+(x*$20000)+(y*$800000),(VDPCTRL)
		moveq	#0,	d1
		jsr		loadASCII2
		endm
		
DefTXT	macro	title,	text
		\title:	dc.b	\text
		\title\_end:	even
		endm

CursorInit	macro	tile,x,y
		move.l	#$40000003+(x*$20000)+(y*$800000),	d0 ; initial offset of cursor (x4 y16)
		move.w	#tile,	d2
		bsr.w	DisplayCurs
		endm