@echo off
chcp 65001 > nul
title شركة هوك للمقاولات - نظام الحضور والتتبع
color 0A

echo.
echo  ================================================================
echo       شركة هوك للمقاولات والإنشاءات (HOK Construction)
echo       نظام الحضور والانصراف وتتبع مواقع العمل بالـ GPS
echo  ================================================================
echo.

set "NODE_EXE=C:\Program Files\nodejs\node.exe"
set "HOK_DIR=%~dp0"

:: التحقق من وجود Node.js
if not exist "%NODE_EXE%" (
    echo  [خطأ] لم يتم العثور على Node.js!
    echo  يرجى تثبيته من: https://nodejs.org
    pause
    exit /b 1
)

echo  [1/3] إيقاف أي نسخة سابقة...
taskkill /F /IM node.exe > nul 2>&1
timeout /t 2 /nobreak > nul

echo  [2/3] تشغيل السيرفر في الخلفية...
:: VBScript يشغّل node بشكل مستقل تماماً (لا يتوقف عند إغلاق الـ BAT)
wscript.exe "%HOK_DIR%start_server.vbs"

echo  [3/3] انتظار بدء السيرفر...
timeout /t 4 /nobreak > nul

:: التحقق من تشغيل السيرفر
netstat -ano 2>nul | findstr ":5000" | findstr "LISTENING" > nul
if errorlevel 1 (
    echo.
    echo  [خطأ] السيرفر لم يبدأ! تحقق من:
    echo  - هل Node.js مثبّت بشكل صحيح؟
    echo  - هل مجلد node_modules موجود؟
    echo.
    pause
    exit /b 1
)

echo.
echo  [✓] السيرفر يعمل بنجاح!
echo.
echo  جاري فتح لوحة التحكم في المتصفح...
:: فتح الرابط بالمتصفح الافتراضي (Chrome)
start "" "http://localhost:5000"

echo.
echo  ================================================================
echo.
echo    البرنامج يعمل الآن!
echo.
echo    لوحة التحكم (للمدير):    http://localhost:5000
echo    بوابة العمال (موبايل):   http://localhost:5000/worker.html
echo.
echo    - لمشاركة الرابط مع العمال شغّل:
echo      تشغيل_الربط_المجاني_للموبايل.bat
echo.
echo    - لإيقاف البرنامج: اضغط أي مفتاح هنا
echo  ================================================================
echo.
pause
taskkill /F /IM node.exe > nul 2>&1
echo  تم إيقاف السيرفر. مع السلامة!
