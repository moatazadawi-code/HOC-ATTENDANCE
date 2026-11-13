# UTF-8 Encoding
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host "================================================================" -ForegroundColor Cyan
Write-Host "     شركة هوك للمقاولات والإنشاءات (HOK Construction)" -ForegroundColor Cyan
Write-Host "     توليد رابط مشفر وآمن (HTTPS) لموبايلات العمال عبر الإنترنت" -ForegroundColor Cyan
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host ""

$hokDir = "C:\Users\user\Desktop\hok"
Set-Location $hokDir

# 1. التحقق من تشغيل سيرفر هوك على المنفذ 5000
Write-Host "[1/3] التحقق من تشغيل سيرفر هوك..." -ForegroundColor Yellow
$portCheck = netstat -ano | Select-String ":5000.*LISTENING"
if (-not $portCheck) {
    Write-Host "السيرفر غير مشغل، جاري بدء السيرفر في الخلفية..." -ForegroundColor DarkYellow
    Start-Process "wscript.exe" -ArgumentList "$hokDir\start_server.vbs"
    Start-Sleep 3
}

Write-Host "السيرفر المحلي يعمل بنجاح على المنفذ 5000 ✓" -ForegroundColor Green
Write-Host ""

# 2. إيقاف أي نسخة قديمة من cloudflared
Stop-Process -Name cloudflared -Force -ErrorAction SilentlyContinue
Start-Sleep 1
Remove-Item "$hokDir\tunnel.log" -ErrorAction SilentlyContinue

# 3. تشغيل Cloudflare Quick Tunnel
Write-Host "[2/3] جاري الاتصال وتوليد رابط HTTPS سحابي مجاني..." -ForegroundColor Yellow

$proc = Start-Process -FilePath "$hokDir\cloudflared.exe" -ArgumentList "tunnel --url http://localhost:5000" -RedirectStandardError "$hokDir\tunnel.log" -PassThru -WindowStyle Minimized

# انتظار الحصول على الرابط
$url = ""
for ($i = 0; $i -lt 25; $i++) {
    Start-Sleep 1
    if (Test-Path "$hokDir\tunnel.log") {
        $logContent = Get-Content "$hokDir\tunnel.log" -Raw -ErrorAction SilentlyContinue
        if ($logContent -match "https://[a-zA-Z0-9-]+\.trycloudflare\.com") {
            $url = $matches[0]
            break
        }
    }
}

if (-not $url) {
    Write-Host "[خطأ] تعذر توليد الرابط السحابي! تأكد من اتصال الإنترنت." -ForegroundColor Red
    Write-Host "اضغط أي مفتاح للإغلاق..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit 1
}

$workerUrl = "$url/worker.html"

# نسخ الرابط للحافظة تلقائياً
Set-Clipboard -Value $workerUrl

Write-Host ""
Write-Host "================================================================" -ForegroundColor Green
Write-Host " ✅ رابط تطبيق العمال جاهز (تم نسخه لحافظة جهازك تلقائياً):" -ForegroundColor Green
Write-Host ""
Write-Host "    $workerUrl" -ForegroundColor White -BackgroundColor DarkGreen
Write-Host ""
Write-Host "================================================================" -ForegroundColor Green
Write-Host ""
Write-Host " 📋 اذهب الآن إلى WhatsApp واضغط (لصق / Paste) أو Ctrl+V لإرساله للعمال" -ForegroundColor Yellow
Write-Host " 🔒 الرابط مشفر (HTTPS) - الـ GPS يعمل فورياً على جميع الهواتف" -ForegroundColor Cyan
Write-Host " ⚠️  تنبيه هام: اترك هذه النافذة مفتوحة طوال فترة عمل العمال" -ForegroundColor Magenta
Write-Host ""
Write-Host "----------------------------------------------------------------"
Write-Host "لإيقاف الرابط السحابي: اضغط Enter أو أغلق هذه النافذة" -ForegroundColor DarkGray

# Wait until user presses Enter or closes window
$null = Read-Host
Stop-Process -Id $proc.Id -Force -ErrorAction SilentlyContinue
Write-Host "تم إيقاف الرابط السحابي."
