@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

REM 變數
set "size=0"
set "freeSpace=0"
set "usedSpace=0"
set "drive_max=819200"
set "targetDrive=E:\copy\"
set "minDate="
set "minFile="
set SOURCE_PATH=D:\
set DEST_PATH=E:\copy\copy

REM 檢查硬碟空間
for /f "tokens=1" %%A in ('powershell -command ^
    "Get-CimInstance Win32_LogicalDisk | Where-Object { $_.DeviceID -eq 'E:' } | ForEach-Object { [Math]::Floor(($_.Size - $_.FreeSpace) / 1MB) }"') do (
    set "usedSpace=%%A"
)
echo 已使用空間：!usedSpace! MB

REM 判斷容量
if !usedSpace! gtr !drive_max! (
    echo 硬碟容量不足，執行刪除舊備份檔
    REM 確保目標磁碟存在
    if not exist "!targetDrive!" (
        echo 錯誤：!targetDrive! 磁碟不存在或無法訪問。
        pause
        goto :end
    )

    REM 列出所有 .zip 文件，排除隱藏和系統檔案
    for /f "delims=" %%f in ('dir "!targetDrive!*.zip" /s /b /a:-h-s') do (
        set "filename=%%~nxf"

        REM 確保文件名長度足夠
        if "!filename!" neq "" (
            set "datePart=!filename:~4,10!"      REM 提取 YYYY-MM_DD 的部分
            if "!datePart!" neq "" (
                set "timePart=!filename:~15,8!"  REM 提取 HH-MM-SS 的部分
                if "!timePart!" neq "" (
                    REM 將日期和時間部分合併成完整日期時間
                    set "fullDate=!datePart!_!timePart!"
    
                    REM 初始化 minDate
                    if not defined minDate (
                        set "minDate=!fullDate!"
                        set "minFile=%%f"
                    ) else (
                        REM 比較日期大小
                        if "!fullDate!" lss "!minDate!" (
                            set "minDate=!fullDate!"
                            set "minFile=%%f"
                        )
                    )
                )
            )
        )
    )

    REM 顯示結果
    if defined minFile (
        echo 最小日期的檔案是：!minFile!
        REM 刪除舊備份檔
        del "!minFile!"
        echo 刪除成功!
    ) else (
        echo 沒有找到任何 .zip 檔案(錯誤!!)
    )

) else (
    echo 硬碟容量充足，執行備份

    REM 生成時間戳
    for /f "tokens=2 delims==" %%i in ('wmic os get localdatetime /value') do set datetime=%%i
    set TIMESTAMP=!datetime:~0,4!-!datetime:~4,2!_!datetime:~8,2!-!datetime:~10,2!_!datetime:~12,2!

    REM 壓縮檔案
    set ZIP_FILE=!DEST_PATH!!TIMESTAMP!.zip
    PowerShell -Command "Compress-Archive -Path '!SOURCE_PATH!\*' -DestinationPath '!ZIP_FILE!' -Force"

    echo 完成備份與清理操作。
) 

:end
endlocal
pause
