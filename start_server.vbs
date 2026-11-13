' VBScript لتشغيل سيرفر هوك بشكل مستقل في الخلفية
' هذا الملف يشغّل Node.js بدون أي نافذة CMD

Dim WshShell
Set WshShell = CreateObject("WScript.Shell")

Dim hokDir
hokDir = Left(WScript.ScriptFullName, InStrRev(WScript.ScriptFullName, "\"))

' ضبط المجلد الحالي
WshShell.CurrentDirectory = hokDir

' تشغيل السيرفر في الخلفية (0 = بدون نافذة, False = لا تنتظر)
WshShell.Run """C:\Program Files\nodejs\node.exe"" """ & hokDir & "server.js""", 0, False

WScript.Quit
