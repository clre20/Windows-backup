@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

:: 設定目標磁碟
set "targetDrive=E:\copy\"

:: 確保目標磁碟存在
if not exist "%targetDrive%" (
    echo 錯誤：%targetDrive% 磁碟不存在或無法訪問。
    goto :end
)

:: 初始化最小日期變數
set "minDate="
set "minFile="

:: 列出所有 .zip 文件，排除隱藏和系統檔案
for /f "delims=" %%f in ('dir "%targetDrive%*.zip" /s /b /a:-h-s') do (
    set "filename=%%~nxf"
    
    :: 確保文件名長度足夠
    if "!filename!" neq "" (
        set "datePart=!filename:~4,10!"  :: 提取 YYYY-MM_DD 的部分
        if "!datePart!" neq "" (
            set "timePart=!filename:~15,8!"  :: 提取 HH-MM-SS 的部分
            if "!timePart!" neq "" (
                :: 將日期和時間部分合併成完整日期時間
                set "fullDate=!datePart!_!timePart!"

                :: 初始化 minDate
                if not defined minDate (
                    set "minDate=!fullDate!"
                    set "minFile=%%f"
                ) else (
                    :: 比較日期大小
                    if "!fullDate!" lss "!minDate!" (
                        set "minDate=!fullDate!"
                        set "minFile=%%f"
                    )
                )
            )
        )
    )
)

:: 顯示結果
if defined minFile (
    echo 最小日期的檔案是：!minFile!
) else (
    echo 沒有找到任何 .zip 檔案
)

:: 刪除檔案
del !minFile!
echo 刪除成功!

:end
pause
