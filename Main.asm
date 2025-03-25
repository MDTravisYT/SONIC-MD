
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
;	Warp mode
		include		"Time Warp Cutscene/Main.asm"
;	Error handler
		include		"_Include/ErrorHandler.asm"

ROM_END:
	END