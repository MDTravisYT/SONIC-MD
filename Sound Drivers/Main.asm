ym2612_a0:		equ $A04000
ym2612_d0:		equ $A04001
ym2612_a1:		equ $A04002
ym2612_d1:		equ $A04003

z80_ram:		equ $A00000	
z80_port_1_control:	equ $A10008
z80_expansion_control:	equ $A1000C
z80_dac3_pitch:		equ $A000EA
Z80_RESET		=	$A11200
z80_dac_status:		equ $A01FFD
z80_dac_sample:		equ $A01FFF
SEGATMSS		=	$A14000
psg_input: equ $C00011

	include		"Sound Drivers/SOUNDRAM.I"
	
resetZ80:	macro
		move.w	#$100,(Z80_RESET).l
		endm

resetZ80a:	macro
		move.w	#0,(Z80_RESET).l
		endm
		
startZ80:       macro
		move.w	#0,(Z80BUS).l
		endm

stopZ80:        macro
		move.w	#$100,(Z80BUS).l
		endm
		
LoadSoundDriver:
		nop	
		stopZ80
		resetZ80
		lea	(Kos_Z80).l,a0	; load sound driver
		lea	(z80_ram).l,a1	; target Z80 RAM
		jsr		KosDec		; decompress
		resetZ80a
		nop	
		nop	
		nop	
		nop	
		resetZ80
		startZ80
		rts	
; End of function SoundDriverLoad
	
	include	"Sound Drivers/driver.asm"