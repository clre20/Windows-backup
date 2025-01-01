@echo off
setlocal enabledelayedexpansion

REM 設定路徑
set SOURCE_PATH=D:\
set DEST_PATH=E:\copy\copy
set MAX_SIZE_MB=666 REM 設置容量限制（MB）

REM 生成時間戳
for /f "tokens=2 delims==" %%i in ('wmic os get localdatetime /value') do set datetime=%%i
set TIMESTAMP=%datetime:~0,4%-%datetime:~4,2%_%datetime:~8,2%-%datetime:~10,2%-%datetime:~12,2%

REM 建立目標文件夾
if not exist "%DEST_PATH%" (
    mkdir "%DEST_PATH%"
)

REM 壓縮檔案
set ZIP_FILE=%DEST_PATH%%TIMESTAMP%.zip
PowerShell -Command "Compress-Archive -Path '%SOURCE_PATH%\*' -DestinationPath '%ZIP_FILE%' -Force"

REM 檢查目標文件夾容量
set total_size=0
for %%f in (%DEST_PATH%\*.zip) do (
    set /a total_size+=%%~zf
)

REM 如果總容量超過最大限制，刪除最舊的ZIP文件
:CHECK_SIZE
if !total_size! GTR !MAX_SIZE_BYTES! (
    for /f "delims=" %%A in ('dir /b /a-d /o-d /t:c "%DEST_PATH%\*.zip"') do (
        set oldest_file=%%A
        del "%DEST_PATH%\!oldest_file!"
        set /a total_size-=%%~zA
        goto CHECK_SIZE
    )
)

echo 完成備份與清理操作。
pause
