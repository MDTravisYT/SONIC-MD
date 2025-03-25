
		include		"_Include/Debugger.asm"
		include		"Level/Initialization.asm"
		include		"Level/_Definitions.i"

ROM_START:
;	Logo mode
		include		"Logo/Main.asm"
;	Title mode
		include		"Title Screen/Main.asm"
;	Level mode
		include		"Level/Palmtree Panic/Act 1 Present.asm"
		
; ==============================================================
; --------------------------------------------------------------
; Debugging modules
; --------------------------------------------------------------

   include   "_Include/ErrorHandler.asm"

; --------------------------------------------------------------
; WARNING!
;	DO NOT put any data from now on! DO NOT use ROM padding!
;	Symbol data should be appended here after ROM is compiled
;	by ConvSym utility, otherwise debugger modules won't be able
;	to resolve symbol names.
; --------------------------------------------------------------

ROM_END:
	END