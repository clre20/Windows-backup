@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

:: 初始化變數
set "size=0"
set "freeSpace=0"
set "usedSpace=0"

@echo off
for /f "tokens=1,2 delims= " %%A in ('powershell -command ^
    "Get-CimInstance Win32_LogicalDisk | Where-Object { $_.DeviceID -eq 'E:' } | ForEach-Object { [Math]::Floor(($_.Size - $_.FreeSpace) / 1MB) }"') do (
    set "usedSpace=%%A"
)

:: 輸出結果
echo 使用空間：%usedSpace% MB

endlocal
pause
