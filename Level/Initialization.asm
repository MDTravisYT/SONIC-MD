; -------------------------------------------------------------------------
; Sonic CD Disassembly
; By Ralakimus 2021
; -------------------------------------------------------------------------
; Level initialization
; -------------------------------------------------------------------------

; -------------------------------------------------------------------------
; MMD header
; -------------------------------------------------------------------------

RAM_START		EQU	$FF0000			; Work RAM start
RAM_END			EQU	$1000000		; Work RAM end
		org 0
	; (ADDED) 68000 vector table
	dc.l	$FFFD00					; Stack pointer (taken from Sega CD BIOS)
	dc.l	JmpTo_Start				; Entry point
	dcb.l	$1A, JmpTo_Error			; Exceptions
	dc.l	JmpTo_HInt				; H-INT
	dc.l	JmpTo_Error				; IRQ5
	dc.l	JmpTo_VInt				; V-INT
	dcb.l	$21, JmpTo_Error			; More exceptions

	; (ADDED) ROM header
	dc.b	"SEGA MEGA DRIVE "
	dc.b	"(C)SEGA 1993.SEP"
	dc.b 	"SONIC THE HEDGEHOG CD PORT BY MDTRAVIS          "
	dc.b 	"SONIC THE HEDGEHOG CD PORT BY MDTRAVIS          "
	dc.b	"GM MK-4407 -00"
	dc.w	0
	dc.b	"J               "
	dc.l	ROM_START, ROM_END-1
	dc.l	RAM_START, RAM_END-1
	dc.b	"            "
	dc.b	"            "
	dc.b	"                                        "
	dc.b	"JUE             "

; -------------------------------------------------------------------------
; Program start
; -------------------------------------------------------------------------

JmpTo_Start:
	jmp	Start

; -------------------------------------------------------------------------
; Error trap
; -------------------------------------------------------------------------

JmpTo_Error:
	jmp	ErrorTrap

; -------------------------------------------------------------------------
; H-INT routine
; -------------------------------------------------------------------------

JmpTo_HInt:
	jmp	HInterrupt

; -------------------------------------------------------------------------
; V-INT routine
; -------------------------------------------------------------------------

JmpTo_VInt:
	jmp	VInterrupt

; -------------------------------------------------------------------------
; Error trap loop
; -------------------------------------------------------------------------

ErrorTrap:
	nop
	nop
	bra.s	ErrorTrap

; -------------------------------------------------------------------------
; Entry point
; -------------------------------------------------------------------------

Start:
	; (ADDED) Stock MD init code
	dc.b	$4A, $B9, $00, $A1, $00, $08, $66, $06, $4A, $79, $00, $A1
	dc.b	$00, $0C, $66, $7C, $4B, $FA, $00, $7C, $4C, $9D, $00, $E0
	dc.b	$4C, $DD, $1F, $00, $10, $29, $EF, $01, $02, $00, $00, $0F
	dc.b	$67, $08, $23, $7C, $53, $45, $47, $41, $2F, $00, $30, $14
	dc.b	$70, $00, $2C, $40, $4E, $66, $72, $17, $1A, $1D, $38, $85
	dc.b	$DA, $47, $51, $C9, $FF, $F8, $28, $9D, $36, $80, $32, $87
	dc.b	$34, $87, $01, $11, $66, $FC, $74, $25, $10, $DD, $51, $CA
	dc.b	$FF, $FC, $34, $80, $32, $80, $34, $87, $2D, $00, $51, $CE
	dc.b	$FF, $FC, $28, $9D, $28, $9D, $76, $1F, $26, $80, $51, $CB
	dc.b	$FF, $FC, $28, $9D, $78, $13, $26, $80, $51, $CC, $FF, $FC
	dc.b	$7A, $03, $17, $5D, $00, $11, $51, $CD, $FF, $FA, $34, $80
	dc.b	$4C, $D6, $7F, $FF, $46, $FC, $27, $00, $60, $6C, $80, $00
	dc.b	$3F, $FF, $01, $00, $00, $A0, $00, $00, $00, $A1, $11, $00
	dc.b	$00, $A1, $12, $00, $00, $C0, $00, $00, $00, $C0, $00, $04
	dc.b	$04, $14, $30, $3C, $07, $6C, $00, $00, $00, $00, $FF, $00
	dc.b	$81, $37, $00, $01, $01, $00, $00, $FF, $FF, $00, $00, $80
	dc.b	$40, $00, $00, $80, $AF, $01, $D9, $1F, $11, $27, $00, $21
	dc.b	$26, $00, $F9, $77, $ED, $B0, $DD, $E1, $FD, $E1, $ED, $47
	dc.b	$ED, $4F, $D1, $E1, $F1, $08, $D9, $C1, $D1, $E1, $F1, $F9
	dc.b	$F3, $ED, $56, $36, $E9, $E9, $81, $04, $8F, $02, $C0, $00
	dc.b	$00, $00, $40, $00, $00, $10, $9F, $BF, $DF, $FF, $4A, $79
	dc.b	$00, $C0, $00, $04
	btst	#6,IOCTRL3			; Have the controller ports been initialized?
	beq.s	.DoInit				; If so, do start RAM clear
	cmpi.l	#'init',initFlag		; Have we already initialized?
	beq.w	.GameInit			; If so, branch

.DoInit:
	lea	unkBuffer,a6			; Clear unknown buffer
	moveq	#0,d7
	move.w	#$400/4-1,d6
	move.w	#$200/4-1,d6

.ClearRAM:
	move.l	d7,(a6)+
	dbf	d6,.ClearRAM			; Clear until finished

	move.b	VERSION,d0			; Get hardware region
	andi.b	#$C0,d0
	move.b	d0,versionCache

	move.l	#'init',initFlag		; Mark as done

.GameInit:
	bsr.w	InitVDP				; Initialize VDP
	jsr		LoadSoundDriver				; Initialize sound driver
	bsr.w	InitControllers			; Initialize joypads

	move.b	#1,(timeZone).l			; (ADDED) Set time zone to present
	move.b	#0,gameMode.w			; Set game mode to "level"

	move.b	#0,gameMode.w	
MainGameLoop:
	move.b	gameMode.w,d0			; Go to the current game mode routine
	andi.w	#%00011100,d0
	jsr		@index(pc,d0.w)
	bra.s	MainGameLoop		

; -------------------------------------------------------------------------
; Game modes
; -------------------------------------------------------------------------
	@index:
		bra.w	LOGO_Jmp
		bra.w	Title_Jmp
		bra.w	LevelStart			; Level
;	Define Game mode constants
GM_LOGO		=	0
GM_TITLE	=	GM_LOGO+4
GM_LEVEL	=	GM_TITLE+4
; -------------------------------------------------------------------------
LOGO_Jmp:	jmp		LOGO				; SEGA
Title_Jmp:	jmp		TITLE				; Title
; -------------------------------------------------------------------------
