' ==============================================================================
' مشغل برنامج هوك الذكي - ضغطة واحدة تفتح البرنامج بدون أي نوافذ أو أوامر سوداء
' ==============================================================================

Dim WshShell, fso
Set WshShell = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")

Dim hokDir, nodeExe, chromeExe
hokDir = "C:\Users\user\Desktop\hok"
nodeExe = "C:\Program Files\nodejs\node.exe"
chromeExe = "C:\Program Files\Google\Chrome\Application\chrome.exe"

WshShell.CurrentDirectory = hokDir

' 1. تشغيل السيرفر في الخلفية بشكل صامت تماماً
If fso.FileExists(nodeExe) Then
    WshShell.Run """" & nodeExe & """ """ & hokDir & "\server.js""", 0, False
Else
    MsgBox "لم يتم العثور على Node.js على الجهاز!" & vbCrLf & "يرجى التأكد من تثبيت Node.js من nodejs.org", vbCritical, "برنامج هوك للمقاولات"
    WScript.Quit
End If

' 2. انتظار ثانية ونصف حتى يكتمل بدء السيرفر
WScript.Sleep 1500

' 3. فتح البرنامج في نافذة سطح مكتب أنيقة بدون أشرطة متصفح
If fso.FileExists(chromeExe) Then
    WshShell.Run """" & chromeExe & """ --app=http://localhost:5000 --window-size=1320,900", 1, False
Else
    WshShell.Run "http://localhost:5000", 1, False
End If

WScript.Quit
