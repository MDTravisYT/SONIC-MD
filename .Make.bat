:: my super awesome compile batch ~
@echo off
"_Bin/time.py"
type _Bin\Credits.txt 2>nul

set ASM68K=_Bin\asm68k.exe /p /o ae-,l.,ow+ /e REGION=0
set CHECKSUM=_Bin\fixheadr.exe

%ASM68K% /e DEMO=0 "Main.asm", "SONIC-MD.BIN", , "SONIC-MD.LST" > SONIC-MD.LOG
if %ERRORLEVEL% equ 0 goto noerror
del time.temp
color 0c
type SONIC-MD.LOG
pause
exit

:noerror
del time.temp
%CHECKSUM% SONIC-MD.BIN
echo Completed!

pause
