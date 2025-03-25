:: my super awesome compile batch ~
@echo off
type _Bin\Credits.txt 2>nul

set ASM68K=_Bin\asm68k.exe /p /o ae-,l.,ow+ /e REGION=0
set CHECKSUM=_Bin\fixheadr.exe

%ASM68K% /e DEMO=0 "Level\Palmtree Panic\Act 1 Present.asm", "SONIC-MD.BIN", , "SONIC-MD.LST"
%CHECKSUM% SONIC-MD.BIN

pause
