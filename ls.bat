@echo off
chcp 65001 >nul
setlocal

:: 設定目標磁碟
set "targetDrive=E:\copy\"

:: 確保目標磁碟存在
if not exist "%targetDrive%" (
    echo 錯誤：%targetDrive% 磁碟不存在或無法訪問。
    goto :end
)

:: 列出所有 .zip 文件，排除隱藏和系統檔案
echo 列出 %targetDrive% 的所有 .zip 文件：
dir "%targetDrive%*.zip" /s /b /a:-h-s

:end
pause
