@echo off
setlocal enabledelayedexpansion

REM 設定路徑
set SOURCE_PATH=D:\
set DEST_PATH=E:\copy\copy

REM 生成時間戳
for /f "tokens=2 delims==" %%i in ('wmic os get localdatetime /value') do set datetime=%%i
set TIMESTAMP=%datetime:~0,4%-%datetime:~4,2%_%datetime:~8,2%-%datetime:~10,2%-%datetime:~12,2%

REM 壓縮檔案
set ZIP_FILE=%DEST_PATH%%TIMESTAMP%.zip
PowerShell -Command "Compress-Archive -Path '%SOURCE_PATH%\*' -DestinationPath '%ZIP_FILE%' -Force"

echo 完成備份與清理操作。
pause
