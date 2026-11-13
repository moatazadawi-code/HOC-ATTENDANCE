' ==============================================================================
' إيقاف برنامج هوك للمقاولات
' ==============================================================================

Dim WshShell
Set WshShell = CreateObject("WScript.Shell")

' إيقاف عملية السيرفر والرابط السحابي في الخلفية
WshShell.Run "taskkill /F /IM node.exe", 0, True
WshShell.Run "taskkill /F /IM cloudflared.exe", 0, True

MsgBox "تم إيقاف تشغيل برنامج هوك وسيرفر الحضور بنجاح.", vbInformation, "برنامج هوك للمقاولات"

WScript.Quit
