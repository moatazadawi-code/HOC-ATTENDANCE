@echo off
chcp 65001 > nul
title شركة هوك - تفعيل رابط الموبايل المجاني للعمال
color 0B

echo.
echo  ================================================================
echo       شركة هوك للمقاولات والإنشاءات (HOK Construction)
echo       رابط سحابي مجاني HTTPS لموبايلات العمال
echo  ================================================================
echo.
echo  هذه الأداة تعطيك رابطاً مجانياً يعمل على أي انترنت مصري
echo  (فودافون / أورنج / اتصالات / WE / 4G) بدون أي تكلفة
echo.

set "NODE_EXE=C:\Program Files\nodejs\node.exe"

:: التحقق من تشغيل السيرفر الأساسي
netstat -ano 2>nul | findstr ":5000" | findstr "LISTENING" > nul
if errorlevel 1 (
    echo  [تنبيه] السيرفر الأساسي غير مشغّل!
    echo  يرجى تشغيل ملف "تشغيل_برنامج_هوك.bat" أولاً
    echo.
    pause
    exit /b 1
)

echo  [1/2] السيرفر يعمل على المنفذ 5000  ✓
echo.
echo  [2/2] جاري توليد الرابط السحابي المجاني...
echo.
echo  ================================================================
echo  انسخ الرابط التالي وأرسله للعمال على واتساب:
echo  (سيكون على شكل: https://xxxx-xxxx.loca.lt/worker.html)
echo.
echo  تنبيه: عند فتح الرابط أول مرة - اضغط "Click to Submit"
echo  ================================================================
echo.

:: تشغيل localtunnel عبر npx مع المسار الصحيح لـ node
"%NODE_EXE%" "%~dp0node_modules\.bin\localtunnel" --port 5000 2>nul || (
    echo  جاري تحميل localtunnel...
    "%NODE_EXE%" "C:\Program Files\nodejs\node_modules\npm\bin\npx-cli.js" localtunnel --port 5000 2>nul || (
        npx localtunnel --port 5000
    )
)

pause
