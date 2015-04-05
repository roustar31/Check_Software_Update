#Region ;**** 参数创建于 ACNWrapper_GUI ****
#AutoIt3Wrapper_Icon=Windows Update.ico
#AutoIt3Wrapper_OutFile=release\CheckUpDate.exe
#AutoIt3Wrapper_UseX64=n
#AutoIt3Wrapper_Res_Comment=软件更新检查工具
#AutoIt3Wrapper_Res_Description=软件更新检查工具
#AutoIt3Wrapper_Res_FileVersion=1.5.0.0
#AutoIt3Wrapper_Res_LegalCopyright=Copyright (c) 2015 睿派克技术论坛. All Rights Reserved.
#AutoIt3Wrapper_Res_Field=OriginalFilename|软件更新检查工具
#AutoIt3Wrapper_Res_Field=ProductName|软件更新检查工具
#AutoIt3Wrapper_Res_Field=ProductVersion|1.5.0.0
#AutoIt3Wrapper_Res_Field=InternalName|软件更新检查工具
#AutoIt3Wrapper_Res_Field=FileDescription|自动检查软件更新
#AutoIt3Wrapper_Res_Field=Comments|自动检查软件更新的工具
#AutoIt3Wrapper_Res_Field=LegalTrademarks|睿派克技术论坛
#AutoIt3Wrapper_Res_Field=CompanyName|睿派克技术论坛
#AutoIt3Wrapper_Res_Field=PowerBy|睿派克技术论坛
#AutoIt3Wrapper_Res_Field=Design|roustar31
#AutoIt3Wrapper_Res_Field=SourceCode|roustar31
#AutoIt3Wrapper_Run_Tidy=Y
#EndRegion ;**** 参数创建于 ACNWrapper_GUI ****

Opt("TrayMenuMode", 1)
#include <Array.au3>
#include <INet.au3>
#include <Process.au3>
#include <File.au3>
#include <IE.au3>
HttpSetProxy(0)
Local $aPid = ProcessList(@ScriptName)
If Not IsArray($aPid) Then Exit
For $i = 1 To $aPid[0][0]
	If $aPid[$i][1] == @AutoItPID Then ContinueLoop
	Exit
Next
TrayTip("提示", "判断联网状态中.......", 3, 1)
Local $Net1 = _RunDOS("ping -n 1 -w 2000 www.baidu.com||exit 303")
Local $Net2 = _RunDOS("ping -n 1 -w 2000 www.sina.cn||exit 303")
If $Net1 = "303" And $Net2 = "303" Then
	TrayTip("提示", "貌似没有联网，程序退出.......", 3, 1)
	Sleep(1500)
	Exit
EndIf

If Not FileExists(@ScriptDir & "\CheckUp.Dat") Then Exit
FileSetAttrib(@ScriptDir & "\CheckUp.Dat", "-HSR")
$taskcheck = IniRead(@ScriptDir & "\CheckUp.Dat", "Task", "ok", "1")
If $taskcheck = "0" Then
	TrayTip("提示", "检测到还没有注册为任务计划，注册为计划任务中.......", 3, 1)
	RunWait(@ComSpec & ' /c ' & 'schtasks /create /sc minute /mo 25 /tn "检查软件更新" /tr ' & @ScriptDir & '\CheckUpDate.exe')
	IniWrite(@ScriptDir & "\CheckUp.Dat", "Task", "ok", "1")
EndIf
TrayTip("提示", "读取本地版本中.......", 3, 1)
$idmpath = RegRead("HKEY_CURRENT_USER\Software\DownloadManager", "ExePath")
If $idmpath = "" Then
	$idmpath = IniRead(@ScriptDir & "\CheckUp.Dat", "IDMExePath", "Path", "")
	If $idmpath = "" Then
		MsgBox(64 + 0, "抱歉", "程序没有检测到IDM可执行程序！" & "建议安装IDM后再次重试！", 35)
		Exit
	EndIf
EndIf
$DownPath = @ScriptDir & "\New"
If Not FileExists($DownPath) Then DirCreate($DownPath)
$OLDNotepad2 = IniRead(@ScriptDir & "\CheckUp.Dat", "Notepad2", "url", "")
$OLDThunderSP = IniRead(@ScriptDir & "\CheckUp.Dat", "ThunderSP", "url", "")
$OLDSystemExplorer = IniRead(@ScriptDir & "\CheckUp.Dat", "SystemExplorer", "url", "")
$OLDAutoruns = IniRead(@ScriptDir & "\CheckUp.Dat", "Autoruns", "date", "")
$OLD7Zip32b = IniRead(@ScriptDir & "\CheckUp.Dat", "7-Zip", "url32b", "")
$OLD7Zip64b = IniRead(@ScriptDir & "\CheckUp.Dat", "7-Zip", "url64b", "")
$OLD7Zip32s = IniRead(@ScriptDir & "\CheckUp.Dat", "7-Zip", "url32s", "")
$OLD7Zip64s = IniRead(@ScriptDir & "\CheckUp.Dat", "7-Zip", "url64s", "")
$OLDsandboxie32 = IniRead(@ScriptDir & "\CheckUp.Dat", "sandboxie", "url32", "")
$OLDsandboxie64 = IniRead(@ScriptDir & "\CheckUp.Dat", "sandboxie", "url64", "")
$OLDWinRAR = IniRead(@ScriptDir & "\CheckUp.Dat", "WinRAR", "EngVer", "")
$OLDWinRARC = IniRead(@ScriptDir & "\CheckUp.Dat", "WinRAR", "ChnVer", "")
$OLDXnView = IniRead(@ScriptDir & "\CheckUp.Dat", "XnView", "ver", "")
$OLDdisktool = IniRead(@ScriptDir & "\CheckUp.Dat", "disktool", "size", "")
$OLDAudioShell = IniRead(@ScriptDir & "\CheckUp.Dat", "AudioShell", "url", "")
$OLDfdminst = IniRead(@ScriptDir & "\CheckUp.Dat", "fdminst", "size", "")
$OLDTeamViewer = IniRead(@ScriptDir & "\CheckUp.Dat", "TeamViewer", "size", "")
$OLDcpuz = IniRead(@ScriptDir & "\CheckUp.Dat", "CPU-Z", "url", "")
$OLD7star = IniRead(@ScriptDir & "\CheckUp.Dat", "7star", "url", "")
$OLDcFos = IniRead(@ScriptDir & "\CheckUp.Dat", "cFosSpeed", "url1", "")
$OLDcFosb = IniRead(@ScriptDir & "\CheckUp.Dat", "cFosSpeed", "url2", "")
$OLDAliIM = IniRead(@ScriptDir & "\CheckUp.Dat", "AliIM", "size", "")
$OLDpicpick = IniRead(@ScriptDir & "\CheckUp.Dat", "picpick", "size", "")
$OLDUltraISO = IniRead(@ScriptDir & "\CheckUp.Dat", "UltraISO", "size", "")
$OLDPowerISO = IniRead(@ScriptDir & "\CheckUp.Dat", "PowerISO", "size", "")
$OLDBeyondCompareDURL = IniRead(@ScriptDir & "\CheckUp.Dat", "BeyondCompare", "url", "")
$OLDccleaner = IniRead(@ScriptDir & "\CheckUp.Dat", "ccleaner", "ver", "")
$OLDrecuva = IniRead(@ScriptDir & "\CheckUp.Dat", "recuva", "ver", "")
$OLDdefraggler = IniRead(@ScriptDir & "\CheckUp.Dat", "defraggler", "ver", "")
$OLDspeccy = IniRead(@ScriptDir & "\CheckUp.Dat", "speccy", "ver", "")
$OLDDGDURL = IniRead(@ScriptDir & "\CheckUp.Dat", "DG", "url", "")
$OLDWPSDURL = IniRead(@ScriptDir & "\CheckUp.Dat", "WPS", "url1", "")
$OLDWPSDURL2 = IniRead(@ScriptDir & "\CheckUp.Dat", "WPS", "url2", "")
$OLDWinSnapDURL = IniRead(@ScriptDir & "\CheckUp.Dat", "WinSnap", "url", "")
$OLDFSCapture = IniRead(@ScriptDir & "\CheckUp.Dat", "FSCapture", "url", "")
$OLDFSViewer = IniRead(@ScriptDir & "\CheckUp.Dat", "FSViewer", "url", "")
$OLDEmEditorDURL32 = IniRead(@ScriptDir & "\CheckUp.Dat", "EmEditor", "url32", "")
$OLDEmEditorDURL64 = IniRead(@ScriptDir & "\CheckUp.Dat", "EmEditor", "url64", "")
$OLDTagScannerDURL = IniRead(@ScriptDir & "\CheckUp.Dat", "TagScanner", "url", "")
$OLDIDMDURL = IniRead(@ScriptDir & "\CheckUp.Dat", "IDM", "url", "")
$OLDPPTVDURL = IniRead(@ScriptDir & "\CheckUp.Dat", "PPTV", "url", "")
$OLDQQDURL = IniRead(@ScriptDir & "\CheckUp.Dat", "QQ", "url", "")
$QQAndOLD = IniRead(@ScriptDir & "\CheckUp.Dat", "QQ", "Android", "")
$QQAndIOLD = IniRead(@ScriptDir & "\CheckUp.Dat", "QQ", "AndroidIntl", "")
$QQANDLiteOLD = IniRead(@ScriptDir & "\CheckUp.Dat", "QQ", "AndroidLite", "")
$QQPCIOLD = IniRead(@ScriptDir & "\CheckUp.Dat", "QQ", "PCIntl", "")
$QQPCLiteOLD = IniRead(@ScriptDir & "\CheckUp.Dat", "QQ", "PCLite", "")
$OLDMp3TagDURL = IniRead(@ScriptDir & "\CheckUp.Dat", "Mp3Tag", "url", "")
$OLDFlashFxpDURL = IniRead(@ScriptDir & "\CheckUp.Dat", "FlashFxp", "url", "")
$OLDEditPlusDURL32 = IniRead(@ScriptDir & "\CheckUp.Dat", "EditPlus", "url32", "")
$OLDEditPlusDURL64 = IniRead(@ScriptDir & "\CheckUp.Dat", "EditPlus", "url64", "")
$OldVersion = IniRead(@ScriptDir & "\CheckUp.Dat", "luckPath", "verion", "")
$KGOldVerion = IniRead(@ScriptDir & "\CheckUp.Dat", "kugou", "verion", "")
$PTOldSIZE = IniRead(@ScriptDir & "\CheckUp.Dat", "pot", "size", "")
$PTOldSIZE1 = IniRead(@ScriptDir & "\CheckUp.Dat", "pot", "size1", "")
$163MUSICOldSIZE = IniRead(@ScriptDir & "\CheckUp.Dat", "163music", "size", "")
$GIFCAMOldSIZE = IniRead(@ScriptDir & "\CheckUp.Dat", "GIFCAM", "ver", "")
$HyperSnapOldSIZE = IniRead(@ScriptDir & "\CheckUp.Dat", "HyperSnap", "ver", "")
$KGDownUrl = "http://downmini.kugou.com/kugou"
$LKDownUrl = "http://chelpus.defcon5.biz/LuckyPatcher.apk"
$LKPathLogsUrl = "http://chelpus.defcon5.biz/Changelogs.txt"
Sleep(2000)
TrayTip("提示", "开始检查 QQ 更新......", 3, 1)
$QQSurls = _INetGetSource("http://im.qq.com/pcqq")
If @error Then
	$QQDURL = $OLDQQDURL
Else
	$QQVs = StringRegExp($QQSurls, '(http://.+?exe)', 3)
	If @error Or $QQVs = "1" Then
		$QQDURL = $OLDQQDURL
	Else
		$QQVerion = $QQVs[0]
		$QQDURL = $QQVerion
		Local $QQVerionSstrings = StringSplit($QQDURL, "/")
	EndIf
EndIf

$QQAndNew = InetGetSize("http://sqdd.myapp.com/myapp/qqteam/AndroidQQ/Android_QQ.apk")
If @error Or $QQAndNew = "1" Then
	$QQAndNew = $QQAndOLD
Else
	$QQAndNew = $QQAndOLD
EndIf

$QQAndISurls = _INetGetSource("http://im.qq.com/download")
If @error Then
	$QQAndINew = $QQAndIOLD
Else
	$QQAndISurls1 = StringRegExp($QQAndISurls, '(http://dldir1.qq.com/qqfile/QQIntl/QQi_wireless.+?apk)', 3)
	If @error Or $QQAndISurls1 = "1" Then
		$QQAndINew = $QQAndIOLD
	Else
		$QQAndINew = $QQAndISurls1[0]
	EndIf
EndIf

$QQPCISurls = _INetGetSource("http://im.qq.com/download")
If @error Then
	$QQPCINew = $QQPCIOLD
Else
	$QQPCISurls1 = StringRegExp($QQPCISurls, '(http://dldir1.qq.com/qqfile/QQIntl/.+?exe)', 3)
	If @error Or $QQPCISurls1 = "1" Then
		$QQPCINew = $QQPCIOLD
	Else
		$QQPCINew = $QQPCISurls1[0]
	EndIf
EndIf

$QQANDLiteSurls = _INetGetSource("http://im.qq.com/download")
If @error Then
	$QQANDLiteNew = $QQANDLiteOLD
Else
	$QQANDLiteSurls1 = StringRegExp($QQANDLiteSurls, '(http://down.myapp.com/myapp/qqteam/Androidlite.+?apk)', 3)
	If @error Or $QQANDLiteSurls1 = "1" Then
		$QQANDLiteNew = $QQANDLiteOLD
	Else
		$QQANDLiteNew = $QQANDLiteSurls1[0]
	EndIf
EndIf

;------------------检查结束----------------------

TrayTip("提示", "开始检查 IDM 更新......", 3, 1)
$IDMSurls = _INetGetSource("http://www.internetdownloadmanager.com/download.html")
If @error Then
	$IDMDURL = $OLDIDMDURL
Else
	$IDMVs = StringRegExp($IDMSurls, '(http://.+?exe)', 3)
	If @error Or $IDMVs = "1" Then
		$IDMDURL = $OLDIDMDURL
	Else
		$IDMDURL = $IDMVs[0]
	EndIf
EndIf
;---------------------IDM检查完毕---------------------
TrayTip("提示", "开始检查 PPTV 更新......", 3, 1)
$PPTVSurls = _INetGetSource("http://app.pptv.com/pc")
If @error Then
	$PPTVDURL = $OLDPPTVDURL
Else
	$PPTVVs = StringRegExp($PPTVSurls, '(http://.+?exe)', 3)
	If @error Or $PPTVVs = "1" Then
		$PPTVDURL = $OLDPPTVDURL
	Else
		$PPTVDURL = $PPTVVs[0]
	EndIf
EndIf
;---------------------PPTV检查完毕---------------------
TrayTip("提示", "开始检查 WinSnap 更新......", 3, 1)
$WinSnapSurls = _INetGetSource("http://www.ntwind.com/software/winsnap.html")
If @error Then
	$WinSnapDURL = $OLDWinSnapDURL
Else
	$WinSnapVs = StringRegExp($WinSnapSurls, '(http://.+?exe)', 3)
	If @error Or $WinSnapVs = "1" Then
		$WinSnapDURL = $OLDWinSnapDURL
	Else
		$WinSnapDURL = $WinSnapVs[0]
	EndIf
EndIf

TrayTip("提示", "开始检查 迅雷极速版 更新......", 3, 1)
$ThunderSPSurls = _INetGetSource("http://vip.xunlei.com/fast_xl/index.html")
If @error Then
	$NEWThunderSP = $OLDThunderSP
Else
	$ThunderSPVs = StringRegExp($ThunderSPSurls, '(http://down.sandai.net/thunderspeed/ThunderSpeed.+?exe)', 3)
	If @error Or $ThunderSPVs = "1" Then
		$NEWThunderSP = $OLDThunderSP
	Else
		$NEWThunderSP = $ThunderSPVs[0]
	EndIf
EndIf

TrayTip("提示", "开始检查 Notepad2-Mod 更新......", 3, 1)
$Notepad2Surls = _INetGetSource("http://xhmikosr.github.io/notepad2-mod/")
If @error Then
	$NEWNotepad2 = $OLDNotepad2
Else
	$Notepad2Vs = StringRegExp($Notepad2Surls, '(https://github.com/XhmikosR/notepad2-mod/releases/download/.+?exe)', 3)
	If @error Or $Notepad2Vs = "1" Then
		$NEWNotepad2 = $OLDNotepad2
	Else
		$NEWNotepad2 = $Notepad2Vs[0]
	EndIf
EndIf

;---------------------WinSnap检查完毕---------------------
TrayTip("提示", "开始检查 BeyondCompare 更新......", 3, 1)
$BeyondCompareSurls = _INetGetSource("http://www.scootersoftware.com/download.php?zz=user_translations")
If @error Then
	$BeyondCompareDURL = $OLDBeyondCompareDURL
Else
	$BeyondCompareVs = StringRegExp($BeyondCompareSurls, '(BCompare-zh.+?exe)', 3)
	If @error Or $BeyondCompareVs = "1" Then
		$BeyondCompareDURL = $OLDBeyondCompareDURL
	Else
		$BeyondCompareDURL = "http://www.scootersoftware.com/" & $BeyondCompareVs[0]
	EndIf
EndIf

;---------------------BeyondCompare检查完毕---------------------

TrayTip("提示", "开始检查 WPS抢鲜版 更新......", 3, 1)
$WPSSurls = _INetGetSource("http://www.wps.cn/product/beta/")
If @error Then
	$WPSDURL = $OLDWPSDURL
Else
	$WPSVs = StringRegExp($WPSSurls, '(http://.+?exe)', 3)
	If @error Or $WPSVs = 1 Then
		$WPSDURL = $OLDWPSDURL
	Else
		$WPSDURL = $WPSVs[0]
	EndIf
EndIf
;---------------------WPS1检查完毕---------------------

TrayTip("提示", "开始检查 WPS正式版 更新......", 3, 1)
$WPSSurls2 = _INetGetSource("http://www.wps.cn/product/wps2013/")
If @error Then
	$WPSDURL2 = $OLDWPSDURL2
Else
	$WPSVs2 = StringRegExp($WPSSurls2, '(http://.+?exe)', 3)
	If @error Or $WPSVs2 = "1" Then
		$WPSDURL2 = $OLDWPSDURL2
	Else
		$WPSDURL2 = $WPSVs2[0]
	EndIf
EndIf
;---------------------WPS2检查完毕---------------------

TrayTip("提示", "开始检查 DiskGenius 更新......", 3, 1)
$DGSurls = _INetGetSource("http://www.diskgenius.cn/download.php")
If @error Then
	$DGDURL = $OLDDGDURL
Else
	$DGVs = StringRegExp($DGSurls, '(http://www.diskgenius.cn/download.+?zip)', 3)
	If @error Or $DGVs = "1" Then
		$DGDURL = $OLDDGDURL
	Else
		$DGVerionx64 = $DGVs[0]
		$DGVerionx86 = $DGVs[1]
		$DGDURL = $DGVerionx64
	EndIf
EndIf
;---------------------DG检查完毕---------------------
TrayTip("提示", "开始检查 CCleaner 更新......", 3, 1)
$ccleanerSurls = _INetGetSource("http://www.piriform.com/ccleaner/version-history")
If @error Then
	$ccleanerDURL = $OLDccleaner
Else
	$ccleanerVs = StringRegExp($ccleanerSurls, '(<strong>v.+?</strong>)', 3)
	If @error Or $ccleanerVs = "1" Then
		$ccleanerDURL = $OLDccleaner
	Else
		$ccleanerDURL = StringTrimLeft(StringTrimRight($ccleanerVs[0], 9), 9)
	EndIf
EndIf
;---------------------ccleaner检查完毕---------------------

TrayTip("提示", "开始检查 Defraggler 更新......", 3, 1)
$defragglerSurls = _INetGetSource("http://www.piriform.com/defraggler/version-history")
If @error Then
	$defragglerDURL = $OLDdefraggler
Else
	$defragglerVs = StringRegExp($defragglerSurls, '(<strong>v.+?</strong>)', 3)
	If @error Or $defragglerVs = "1" Then
		$defragglerDURL = $OLDdefraggler
	Else
		$defragglerDURL = StringTrimLeft(StringTrimRight($defragglerVs[0], 9), 9)
	EndIf
EndIf
;---------------------defraggler检查完毕---------------------

TrayTip("提示", "开始检查 Recuva 更新......", 3, 1)
$recuvaSurls = _INetGetSource("http://www.piriform.com/recuva/version-history")
If @error Then
	$recuvaDURL = $OLDrecuva
Else
	$recuvaVs = StringRegExp($recuvaSurls, '(<strong>v.+?</strong>)', 3)
	If @error Or $recuvaVs = "1" Then
		$recuvaDURL = $OLDrecuva
	Else
		$recuvaDURL = StringTrimLeft(StringTrimRight($recuvaVs[0], 9), 9)
	EndIf
EndIf
;---------------------recuva检查完毕---------------------

TrayTip("提示", "开始检查 Speccy 更新......", 3, 1)
$speccySurls = _INetGetSource("http://www.piriform.com/speccy/version-history")
If @error Then
	$speccyDURL = $OLDspeccy
Else
	$speccyVs = StringRegExp($speccySurls, '(<strong>v.+?</strong>)', 3)
	If @error Or $speccyVs = "1" Then
		$speccyDURL = $OLDspeccy
	Else
		$speccyDURL = StringTrimLeft(StringTrimRight($speccyVs[0], 9), 9)
	EndIf
EndIf
;---------------------speccy检查完毕---------------------

TrayTip("提示", "开始检查 EmEditor 更新......", 3, 1)
$EmEditorSurls = _INetGetSource("https://www.emeditor.com/download/")
If @error Then
	$EmEditorDURL32 = $OLDEmEditorDURL32
	$EmEditorDURL64 = $OLDEmEditorDURL64
Else
	$EmEditorVs = StringRegExp($EmEditorSurls, '(http://files.emeditor.com/emed.+?portable.zip)', 3)
	If @error Or $EmEditorVs = "1" Then
		$EmEditorDURL32 = $OLDEmEditorDURL32
		$EmEditorDURL64 = $OLDEmEditorDURL64
	Else
		$EmEditorVerion1 = $EmEditorVs[0]
		$EmEditorVerion2 = $EmEditorVs[1]
		$EmEditorDURL64 = $EmEditorVerion2
		$EmEditorDURL32 = StringReplace($EmEditorDURL64, "emed64", "emed32")
	EndIf
EndIf
;-----------------EmEditor检查完毕
TrayTip("提示", "开始检查 TagScanner 更新......", 3, 1)
$TagScannerSurls = _INetGetSource("http://www.xdlab.ru/en/download.htm")
If @error Then
	$TagScannerDURL = $OLDTagScannerDURL
Else
	$TagScannerVs = StringRegExp($TagScannerSurls, '(files/.+?.zip)', 3)
	If @error Or $TagScannerVs = "1" Then
		$TagScannerDURL = $OLDTagScannerDURL
	Else
		$TagScannerDURL = "http://www.xdlab.ru/" & $TagScannerVs[0]
	EndIf
EndIf
;---------------------TagScanner检查完毕---------------------
TrayTip("提示", "开始检查 FlashFXP 更新......", 3, 1)
$FlashFxpSurls = _INetGetSource("http://www.flashfxp.com/download-portable")
If @error Then
	$FlashFxpDURL = $OLDFlashFxpDURL
Else
	$FlashFxpVs = StringRegExp($FlashFxpSurls, '(location = ".+?exe)', 3)
	If @error Or $FlashFxpVs = "1" Then
		$FlashFxpDURL = $OLDFlashFxpDURL
	Else
		$FlashFxpDURL = StringTrimLeft($FlashFxpVs[0], 12)
	EndIf
EndIf
;------------------FlashFxp检查结束----------------------
TrayTip("提示", "开始检查 EditPlus 更新......", 3, 1)
$EditPlusSurls = _INetGetSource("http://www.editplus.com/trouble.html")
If @error Then
	$EditPlusDURL32 = $OLDEditPlusDURL32
	$EditPlusDURL64 = $OLDEditPlusDURL64
Else
	$EditPlusVs = StringRegExp($EditPlusSurls, '(<a href="ftp.+?exe)', 3)
	If @error Or $EditPlusVs = "1" Then
		$EditPlusDURL32 = $OLDEditPlusDURL32
		$EditPlusDURL64 = $OLDEditPlusDURL64
	Else
		$EditPlusVerion32 = StringTrimLeft($EditPlusVs[0], 19)
		$EditPlusVerion64 = StringTrimLeft($EditPlusVs[1], 19)
		$EditPlusDURL32 = "http://www.editplus.com/ftp/" & $EditPlusVerion32
		$EditPlusDURL64 = "http://www.editplus.com/ftp/" & $EditPlusVerion64
	EndIf
EndIf
;------------------Editplus检查结束----------------------
TrayTip("提示", "开始检查 Mp3Tag 更新......", 3, 1)
$Mp3TagSurls = _INetGetSource("http://forums.mp3tag.de/index.php?showtopic=57")
If @error Then
	$Mp3TagDURL = $OLDMp3TagDURL
Else
	$Mp3TagVs = StringRegExp($Mp3TagSurls, '(http://download.+?exe)', 3)
	If @error Or $Mp3TagVs = "1" Then
		$Mp3TagDURL = $OLDMp3TagDURL
	Else
		$Mp3TagDURL = $Mp3TagVs[0]
	EndIf
EndIf
;------------------Mp3Tag检查结束----------------------
TrayTip("提示", "开始检查 PowerISO 更新......", 3, 1)
$NewPowerISO = InetGetSize("http://www.poweriso-files.com/PowerISO6.exe")
If @error Or $NewPowerISO = "0" Then
	$NewPowerISO = $OLDPowerISO
EndIf
;------------------PowerISO检查结束----------------------
TrayTip("提示", "开始检查 PicPick 更新......", 3, 1)
$NewPicPick = InetGetSize("http://www.nteworks.com/latestdownload/picpick_portable.zip")
If @error Or $NewPicPick = "0" Then
	$NewPicPick = $OLDpicpick
EndIf
;------------------PicPick检查结束----------------------

TrayTip("提示", "开始检查 UltraISO 更新......", 3, 1)
$NewUltraISO = InetGetSize("http://dw.ezbsys.net/uiso9_pe.exe")
If @error Or $NewUltraISO = "0" Then
	$NewUltraISO = $OLDUltraISO
EndIf
;------------------UltraISO 检查结束----------------------

TrayTip("提示", "开始检查 阿里旺旺买家版 更新......", 3, 1)
$NewAliIM = InetGetSize("http://download.wangwang.taobao.com/AliIm_taobao.php")
If @error Or $NewAliIM = "0" Then
	$NewAliIM = $OLDAliIM
EndIf
;------------------阿里旺旺买家版 检查结束----------------------

TrayTip("提示", "开始检查 PotPlayer 更新......", 3, 1)
$POTDownUrl = "http://117.52.4.235/beta/PotPlayerSetup.exe"
$POTDownUrl1 = "http://get.daum.net/PotPlayer/v3/PotPlayerSetup.exe"
$PTNEWSIZE = InetGetSize($POTDownUrl, 1)
$PTNEWSIZE1 = InetGetSize($POTDownUrl1, 1)
;------------------PotPlayer检查结束----------------------


TrayTip("提示", "开始检查 TeamViewer 更新......", 3, 1)
$TeamViewerNEW = InetGetSize("http://downloadap3.teamviewer.com/download/TeamViewerPortable.zip", 1)
If @error Or $TeamViewerNEW = "0" Then
	$TeamViewerNEW = $OLDTeamViewer
EndIf
;------------------TeamViewer检查结束----------------------

TrayTip("提示", "开始检查 FDM 更新......", 3, 1)
$fdminstNEW = InetGetSize("http://f0.freedownloadmanager.org/fdminst.exe", 1)
If @error Or $fdminstNEW = "0" Then
	$fdminstNEW = $OLDfdminst
EndIf
;------------------fdminst检查结束----------------------

TrayTip("提示", "开始检查 网易云音乐 更新......", 3, 1)
$163MUSICNEWSIZE = InetGetSize("http://music.163.com/api/pc/download/latest", 1)
If @error Or $163MUSICNEWSIZE = "0" Then
	$163MUSICNEWSIZE = $163MUSICOldSIZE
EndIf
;------------------网易云音乐检查结束----------------------
TrayTip("提示", "开始检查  FastStone Capture 更新......", 3, 1)
$FSCaptureSurls = _INetGetSource("http://www.faststone.org/FSCapturerDownload.htm")
If @error Then
	$FSCapture = $OLDFSCapture
Else
	$FSCaptures = StringRegExp($FSCaptureSurls, '(http://www.faststonesoft.net/DN/FSCapture.+?zip)', 3)
	If @error Then $FSCapture = $OLDFSCapture
	$FSCapture = $FSCaptures[1]
EndIf
;------------------FSCapture检查结束----------------------

TrayTip("提示", "开始检查  FastStone Image Viewer 更新......", 3, 1)
$FSViewerSurls = _INetGetSource("http://www.faststone.org/FSViewerDownload.htm")
If @error Then
	$NEWFSViewer = $OLDFSViewer
Else
	$FSViewers = StringRegExp($FSViewerSurls, '(http://www.faststonesoft.net/DN/FSViewer.+?zip)', 3)
	If @error Then $NEWFSViewer = $OLDFSViewer
	$NEWFSViewer = $FSViewers[1]
EndIf
;------------------FastStone Image Viewer检查结束----------------------

TrayTip("提示", "开始检查 HyperSnap 更新......", 3, 1)

$HyperUrls = _INetGetSource("http://www.hyperionics.com/hsdx/downloads.asp")
If @error Then
	$HyperSnapNEWSIZE = $HyperSnapOldSIZE
Else
	$HyperVERS = StringRegExp($HyperUrls, '(- ver. .+?<br>)', 3)
	If @error Or $HyperVERS = "1" Then
		$HyperSnapNEWSIZE = $HyperSnapOldSIZE
	Else
		$HyperSnapNEWSIZE = StringTrimRight(StringTrimLeft($HyperVERS[0], 7), 4)
	EndIf
EndIf
;------------------HyperSnap检查结束----------------------
TrayTip("提示", "开始检查 GifCam 更新......", 3, 1)
$GIFCAMNEWSIZE = _INetGetSource("http://blog.bahraniapps.com/category/gifcam/")
If @error Then
	$GIFCAMNEWSIZE = $GIFCAMOldSIZE
Else
	$GIFCAMVERS = StringRegExp($GIFCAMNEWSIZE, '(http://blog.bahraniapps.com/gifcam-.+?/)', 3)
	If @error Or $GIFCAMVERS Then
		$GIFCAMNEWSIZE = $GIFCAMOldSIZE
	Else
		$GIFCAMNEWSIZE = StringReplace(StringTrimRight(StringRight($GIFCAMVERS[0], 4), 1), "-", ".", 0, 0)
	EndIf
EndIf

TrayTip("提示", "开始检查 幸运破解器 更新......", 3, 1)
$Logsget = InetGet($LKPathLogsUrl, @ScriptDir & "\New\Changelogs.txt", 1, 0)

$NewVersion = FileReadLine(@ScriptDir & "\New\Changelogs.txt", 1)
If @error Then
	$NewVersion = $OldVersion
EndIf

TrayTip("提示", "开始检查 酷狗音乐 更新......", 3, 1)
For $iK = 1 To 10 Step 1
	$KGNewVerion = $KGOldVerion + $iK
	$KGIfNew = InetGetSize($KGDownUrl & $KGNewVerion & ".exe", 1)
Next

TrayTip("提示", "开始检查  cFosSpeed 更新......", 3, 1)
$cFosSurls = _INetGetSource("http://www.cfos.de/zh-cn/download/download.htm")
If @error Then
	$NewcFos = $OLDcFos
Else
	$cFosSurls1 = StringRegExp($cFosSurls, '(/cfosspeed-v.+?exe)', 3)
	If @error Or $cFosSurls1 = "1" Then
		$NewcFos = $OLDcFos
	Else
		$NewcFos = 'http://www.cfos.de' & $cFosSurls1[0]
	EndIf
EndIf
$cFosSurlsb = _INetGetSource("http://www.cfos.de/zh-cn/beta/index.htm")
If @error Then
	$NewcFosb = $OLDcFosb
Else
	$cFosSurls1b = StringRegExp($cFosSurlsb, '(/beta/cfosspeed-v.+?exe)', 3)
	If @error Or $cFosSurls1b = "1" Then
		$NewcFosb = $OLDcFosb
	Else
		$NewcFosb = 'http://www.cfos.de' & $cFosSurls1b[0]
	EndIf
EndIf

TrayTip("提示", "开始检查  七星浏览器 更新......", 3, 1)
$7starurls = _INetGetSource("http://www.qixing123.com/down.php")
If @error Then
	$New7star = $OLD7star
Else
	$7starurls1 = StringRegExp($7starurls, '(http://down.qixing123.com.+?exe)', 3)
	If @error Or $7starurls1 = "1" Then
		$New7star = $OLD7star
	Else
		$New7star = $7starurls1[0]
	EndIf
EndIf
TrayTip("提示", "开始检查  CPU-Z 更新......", 3, 1)
$cpuzurls = _INetGetSource("http://www.cpuid.com/softwares/cpu-z.html")
If @error Then
	$Newcpuz = $OLDcpuz
Else
	$cpuzurls1 = StringRegExp($cpuzurls, '(/downloads/cpu-z/cpu-z_.+?cn.zip)', 3)
	If @error Or $cpuzurls1 = "1" Then
		$Newcpuz = $OLDcpuz
	Else
		$Newcpuz = 'http://www.cpuid.com' & $cpuzurls1[0]
	EndIf
EndIf

TrayTip("提示", "开始检查  AudioShell 更新......", 3, 1)
$AudioShellurls = _INetGetSource("http://www.softpointer.com/download.htm")
If @error Then
	$NewAudioShell = $OLDAudioShell
Else
	$AudioShellurls1 = StringRegExp($AudioShellurls, '(downloads/AudioShell.+?.exe)', 3)
	If @error Or $AudioShellurls1 = "1" Then
		$NewAudioShell = $OLDAudioShell
	Else
		$NewAudioShell = 'http://www.softpointer.com/' & $AudioShellurls1[0]
	EndIf
EndIf

TrayTip("提示", "开始检查 Sandboxie 更新......", 3, 1)
$sandboxieurls = _INetGetSource("http://www.sandboxie.com/index.php?AllVersions")
If @error Then
	$Newsandboxie32 = $OLDsandboxie32
	$Newsandboxie64 = $OLDsandboxie64
Else
	$sandboxieurls1 = StringRegExp($sandboxieurls, '(http://www.sandboxie.com/attic/SandboxieInstall32.+?.exe)', 3)
	$sandboxieurls2 = StringRegExp($sandboxieurls, '(http://www.sandboxie.com/attic/SandboxieInstall64.+?.exe)', 3)
	If @error Then
		$Newsandboxie32 = $OLDsandboxie32
		$Newsandboxie64 = $OLDsandboxie64
	Else
		$Newsandboxie32 = $sandboxieurls1[0]
		$Newsandboxie64 = $sandboxieurls2[0]
	EndIf
EndIf

TrayTip("提示", "开始检查 7-Zip 更新......", 3, 1)
$7Zipurls = _INetGetSource("http://www.7-zip.org/download.html")
If @error Then
	$New7Zip32b = $OLD7Zip32b
	$New7Zip64b = $OLD7Zip64b
	$New7Zip32s = $OLD7Zip32s
	$New7Zip64s = $OLD7Zip64s
Else
	$7Zipurls1 = StringRegExp($7Zipurls, '(a/7z.+?.msi)', 3)
	$7Zipurls2 = StringRegExp($7Zipurls, '(a/7z.+?64.msi)', 3)
	If @error Then
		$New7Zip32b = $OLD7Zip32b
		$New7Zip64b = $OLD7Zip64b
		$New7Zip32s = $OLD7Zip32s
		$New7Zip64s = $OLD7Zip64s
	Else
		$New7Zip32b = "http://d.7-zip.org/" & $7Zipurls1[0]
		$New7Zip64b = "http://d.7-zip.org/" & $7Zipurls2[0]
		$New7Zip32s = "http://d.7-zip.org/" & $7Zipurls1[2]
		$New7Zip64s = "http://d.7-zip.org/" & $7Zipurls2[1]
	EndIf
EndIf

TrayTip("提示", "开始检查  分区助手 更新......", 3, 1)
Local $oHTTPcn = ObjCreate('microsoft.xmlhttp')
$oHTTPcn.Open('get', "http://disktool.cn/download.html", 0)
$oHTTPcn.Send()
Local $Strcn = BinaryToString($oHTTPcn.responseBody, 4)
$disktoolS1 = StringRegExp($Strcn, '(版本.+?大小)', 3)
If @error Then
	$Newdisktool = $OLDdisktool
Else
	$Newdisktool = StringStripCR(StringStripWS(StringTrimRight(StringTrimLeft($disktoolS1[0], 3), 2), 8))
EndIf

TrayTip("提示", "开始检查  XnView 更新......", 3, 1)
$XnViewurls = _INetGetSource("http://www.xnview.com/en/xnview")
If @error Then
	$NewXnView = $OLDXnView
Else
	$XnViewurls1 = StringRegExp($XnViewurls, '(>Version.+?</)', 3)
	If @error Then $NewXnView = $OLDXnView
	$NewXnView = StringTrimRight(StringTrimLeft($XnViewurls1[0], 1), 2)
EndIf
TrayTip("提示", "开始检查  WinRAR 更新......", 3, 1)
$WinRARurls = _INetGetSource("http://www.rarlab.com")
If @error Then
	$NewWinRAR = $OLDWinRAR
	$NewWinRARC = $OLDWinRARC
Else
	$WinRARurls1 = StringRegExp($WinRARurls, '(>WinRAR and RAR.+?release)', 3)
	If @error Then
		$NewWinRAR = $OLDWinRAR
		$NewWinRARC = $OLDWinRARC
	Else
		$NewWinRAR = StringStripWS(StringReplace(StringTrimRight(StringTrimLeft($WinRARurls1[0], 16), 8), ".", " ", 0, 0), 8)
		$NewWinRAR32EngUrl = "http://rarlab.com/rar/wrar" & $NewWinRAR & ".exe"
		$NewWinRAR64EngUrl = "http://rarlab.com/rar/winrar-x64-" & $NewWinRAR & ".exe"
		If StringInStr($WinRARurls, "/rar/wrar" & $NewWinRAR & "sc.exe", 0) <> 0 Then
			$NewWinRARC = $NewWinRAR
			$NewWinRAR32ChnUrl = "http://rarlab.com/rar/wrar" & $NewWinRAR & "sc.exe"
			$NewWinRAR64ChnUrl = "http://rarlab.com/rar/winrar-x64-" & $NewWinRAR & "sc.exe"
		EndIf
	EndIf
EndIf

TrayTip("提示", "开始检查  Autoruns 更新......", 3, 1)
$Autorunsurls = _INetGetSource("https://technet.microsoft.com/en-us/sysinternals/bb963902")
If @error Then
	$NewAutoruns = $OLDAutoruns
Else
	$Autorunsurls1 = StringRegExp($Autorunsurls, '(Published:.+?</p)', 3)
	If @error Then $NewAutoruns = $OLDAutoruns
	$NewAutoruns = StringTrimRight(StringTrimLeft($Autorunsurls1[0], 11), 3)
EndIf

TrayTip("提示", "开始检查  System Explorer 更新......", 3, 1)
$SystemExplorerurls = _INetGetSource("http://systemexplorer.net/download.php")
If @error Then
	$NewSystemExplorer = $OLDSystemExplorer
Else
	$SystemExplorerurls1 = StringRegExp($SystemExplorerurls, '(/download-archive.+?.exe)', 3)
	If @error Then $NewSystemExplorer = $OLDSystemExplorer
	$NewSystemExplorer = "http://systemexplorer.net" & StringReplace(StringReplace($SystemExplorerurls1[0], "SystemExplorerSetup", "SystemExplorerPortable"), ".exe", ".zip")
EndIf

TrayTip("提示", "所有软件更新检查完毕！开始对比版本......", 3, 1)
Sleep(1000)
If $NewVersion <> $OldVersion Then
	TrayTip("提示", "检查到 LuckyPatcher 最新版，版本为：" & $NewVersion & "开始下载......", 8, 1)
	Beep(600, 1000)
	If FileExists(@ScriptDir & "\New\LuckyPatcher.apk") Then FileDelete(@ScriptDir & "\New\LuckyPatcher.apk")
	ShellExecute($idmpath, '/n /q /d ' & $LKDownUrl & ' /p ' & $DownPath & ' /f LuckyPatcher.apk', @ScriptDir & "\New", "")
	IniWrite(@ScriptDir & "\CheckUp.Dat", "luckPath", "verion", $NewVersion)
EndIf
FileClose($NewVersion)
If $KGIfNew <> 0 Then
	TrayTip("提示", "检查到 酷狗 最新版，版本为：" & $KGNewVerion & "开始下载......", 8, 1)
	Beep(600, 1000)
	$NewkugouUrl = $KGDownUrl & $KGNewVerion & ".exe"
	ShellExecute($idmpath, '/n /q /d ' & $NewkugouUrl & ' /p ' & $DownPath, @ScriptDir & "\New", "")
	IniWrite(@ScriptDir & "\CheckUp.Dat", "kugou", "verion", $KGNewVerion)
EndIf

If $PTNEWSIZE <> $PTOldSIZE Then
	TrayTip("提示", "检查到 PotPlayer 测试版 最新版，新版大小为：" & $PTNEWSIZE & "开始下载......", 8, 1)
	Beep(600, 1000)
	If FileExists(@ScriptDir & "\New\PotPlayerSetupbeta.exe") Then FileDelete(@ScriptDir & "\New\PotPlayerSetupbeta.exe")
	ShellExecute($idmpath, '/n /q /d ' & $POTDownUrl & ' /p ' & $DownPath & ' /f PotPlayerSetupbeta.exe', @ScriptDir & "\New", "")
	IniWrite(@ScriptDir & "\CheckUp.Dat", "pot", "size", $PTNEWSIZE)
EndIf

If $PTNEWSIZE1 <> $PTOldSIZE1 Then
	TrayTip("提示", "检查到 PotPlayer 测试版 最新版，新版大小为：" & $PTNEWSIZE1 & "开始下载......", 8, 1)
	Beep(600, 1000)
	If FileExists(@ScriptDir & "\New\PotPlayerSetup.exe") Then FileDelete(@ScriptDir & "\New\PotPlayerSetup.exe")
	ShellExecute($idmpath, '/n /q /d ' & $POTDownUrl1 & ' /p ' & $DownPath & ' /f PotPlayerSetup.exe', @ScriptDir & "\New", "")
	IniWrite(@ScriptDir & "\CheckUp.Dat", "pot", "size1", $PTNEWSIZE1)
EndIf



If $163MUSICNEWSIZE <> $163MUSICOldSIZE Then
	TrayTip("提示", "检查到 网易云音乐 正式版 最新版，新版大小为：" & $163MUSICNEWSIZE & "开始下载......", 8, 1)
	Beep(600, 1000)
	If FileExists(@ScriptDir & "\New\163music.exe") Then FileDelete(@ScriptDir & "\New\163music.exe")
	ShellExecute($idmpath, '/n /q /d "http://music.163.com/api/pc/download/latest" /p ' & $DownPath & ' /f 163music.exe', @ScriptDir & "\New", "")
	IniWrite(@ScriptDir & "\CheckUp.Dat", "163music", "size", $163MUSICNEWSIZE)
EndIf
If $OLDIDMDURL <> $IDMDURL Then
	TrayTip("提示", "检查到 IDM 最新版，新版开始下载......", 8, 1)
	Beep(600, 1000)
	If FileExists(@ScriptDir & "\New\IDM.exe") Then FileDelete(@ScriptDir & "\New\IDM.exe")
	ShellExecute($idmpath, '/n /q /d ' & $IDMDURL & ' /p ' & $DownPath & ' /f IDM.EXE', @ScriptDir & "\New", "")
	IniWrite(@ScriptDir & "\CheckUp.Dat", "IDM", "url", $IDMDURL)
EndIf

If $OLDPPTVDURL <> $PPTVDURL Then
	TrayTip("提示", "检查到 PPTV 最新版，新版开始下载......", 8, 1)
	Beep(600, 1000)
	If FileExists(@ScriptDir & "\New\PPTV.exe") Then FileDelete(@ScriptDir & "\New\PPTV.exe")
	ShellExecute($idmpath, '/n /q /d ' & $PPTVDURL & ' /p ' & $DownPath & ' /f PPTV.EXE', @ScriptDir & "\New", "")
	IniWrite(@ScriptDir & "\CheckUp.Dat", "PPTV", "url", $PPTVDURL)
EndIf

If $OLDWinSnapDURL <> $WinSnapDURL Then
	TrayTip("提示", "检查到 WinSnap 最新版，新版开始下载......", 8, 1)
	Beep(600, 1000)
	If FileExists(@ScriptDir & "\New\WinSnap.exe") Then FileDelete(@ScriptDir & "\New\WinSnap.exe")
	ShellExecute($idmpath, '/n /q /d ' & $WinSnapDURL & ' /p ' & $DownPath & ' /f WinSnap.EXE', @ScriptDir & "\New", "")
	IniWrite(@ScriptDir & "\CheckUp.Dat", "WinSnap", "url", $WinSnapDURL)
EndIf

If $OLDWPSDURL2 <> $WPSDURL2 Then
	TrayTip("提示", "检查到 WPS 正式版 最新版，新版开始下载......", 8, 1)
	Beep(600, 1000)
	If FileExists(@ScriptDir & "\New\WPS.exe") Then FileDelete(@ScriptDir & "\New\WPS.exe")
	ShellExecute($idmpath, '/n /q /d ' & $WPSDURL2 & ' /p ' & $DownPath & ' /f WPS.exe', @ScriptDir & "\New", "")
	IniWrite(@ScriptDir & "\CheckUp.Dat", "WPS", "url2", $WPSDURL2)
EndIf

If $OLDWPSDURL <> $WPSDURL Then
	TrayTip("提示", "检查到 WPS 抢鲜版 最新版，新版开始下载......", 8, 1)
	Beep(600, 1000)
	If FileExists(@ScriptDir & "\New\WPSBeta.exe") Then FileDelete(@ScriptDir & "\New\WPSBeta.exe")
	ShellExecute($idmpath, '/n /q /d ' & $WPSDURL & ' /p ' & $DownPath & ' /f WPSBeta.exe', @ScriptDir & "\New", "")
	IniWrite(@ScriptDir & "\CheckUp.Dat", "WPS", "url1", $WPSDURL)
EndIf

If $OLDDGDURL <> $DGDURL Then
	TrayTip("提示", "检查到 DiskGenius 最新版，新版开始下载......", 8, 1)
	Beep(600, 1000)
	If FileExists(@ScriptDir & "\New\DGX64.zip") Then FileDelete(@ScriptDir & "\New\DGX64.zip")
	If FileExists(@ScriptDir & "\New\DGX86.zip") Then FileDelete(@ScriptDir & "\New\DGX86.zip")
	ShellExecute($idmpath, '/n /q /d ' & $DGVerionx64 & ' /p ' & $DownPath & ' /f DGX64.zip', @ScriptDir & "\New", "")
	ShellExecute($idmpath, '/n /q /d ' & $DGVerionx86 & ' /p ' & $DownPath & ' /f DGX86.zip', @ScriptDir & "\New", "")
	IniWrite(@ScriptDir & "\CheckUp.Dat", "DG", "url", $DGDURL)
EndIf

If $OLDccleaner <> $ccleanerDURL Then
	TrayTip("提示", "检查到 CCleaner 最新版" & $ccleanerDURL & "，新版开始下载......", 8, 1)
	Beep(600, 1000)
	$ccleanerDURL2 = StringSplit($ccleanerDURL, ".")
	$ccleanerDURL3 = "http://download.piriform.com/ccsetup" & $ccleanerDURL2[1] & $ccleanerDURL2[2] & "pro.exe"
	ShellExecute($idmpath, '/n /q /d ' & $ccleanerDURL3 & ' /p ' & $DownPath & ' /f ccsetuppro.exe', @ScriptDir & "\New", "")
	IniWrite(@ScriptDir & "\CheckUp.Dat", "ccleaner", "ver", $ccleanerDURL)
EndIf

If $OLDspeccy <> $speccyDURL Then
	TrayTip("提示", "检查到 Speccy 最新版" & $speccyDURL & "，新版开始下载......", 8, 1)
	Beep(600, 1000)
	$speccyDURL2 = StringSplit($speccyDURL, ".")
	$speccyDURL3 = "http://download.piriform.com/spsetup" & $speccyDURL2[1] & $speccyDURL2[2] & ".exe"
	ShellExecute($idmpath, '/n /q /d ' & $speccyDURL3 & ' /p ' & $DownPath, @ScriptDir & "\New", "")
	IniWrite(@ScriptDir & "\CheckUp.Dat", "speccy", "ver", $speccyDURL)
EndIf

If $OLDrecuva <> $recuvaDURL Then
	TrayTip("提示", "检查到 Recuva 最新版" & $recuvaDURL & "，新版开始下载......", 8, 1)
	Beep(600, 1000)
	$recuvaDURL2 = StringSplit($recuvaDURL, ".")
	$recuvaDURL3 = "http://download.piriform.com/spsetup" & $recuvaDURL2[1] & $recuvaDURL2[2] & ".exe"
	ShellExecute($idmpath, '/n /q /d ' & $recuvaDURL3 & ' /p ' & $DownPath, @ScriptDir & "\New", "")
	IniWrite(@ScriptDir & "\CheckUp.Dat", "recuva", "ver", $recuvaDURL)
EndIf

If $OLDdefraggler <> $defragglerDURL Then
	TrayTip("提示", "检查到 Defraggler 最新版" & $defragglerDURL & "，新版开始下载......", 8, 1)
	Beep(600, 1000)
	$defragglerDURL2 = StringSplit($defragglerDURL, ".")
	$defragglerDURL3 = "http://download.piriform.com/dfsetup" & $defragglerDURL2[1] & $defragglerDURL2[2] & ".exe"
	ShellExecute($idmpath, '/n /q /d ' & $defragglerDURL3 & ' /p ' & $DownPath, @ScriptDir & "\New", "")
	IniWrite(@ScriptDir & "\CheckUp.Dat", "defraggler", "ver", $defragglerDURL)
EndIf

If $OLDTagScannerDURL <> $TagScannerDURL Then
	TrayTip("提示", "检查到 TagScanner 最新版，新版开始下载......", 8, 1)
	Beep(600, 1000)
	If FileExists(@ScriptDir & "\New\TagScanner.zip") Then FileDelete(@ScriptDir & "\New\TagScanner.zip")
	ShellExecute($idmpath, '/n /q /d ' & $TagScannerDURL & ' /p ' & $DownPath, @ScriptDir & "\New", "")
	IniWrite(@ScriptDir & "\CheckUp.Dat", "TagScanner", "url", $TagScannerDURL)
EndIf

If $OLDQQDURL <> $QQDURL Then
	TrayTip("提示", "检查到 PC QQ 正式版 最新版，新版开始下载......", 8, 1)
	Beep(600, 1000)
	Local $QQFileName = $QQVerionSstrings[6] & "." & $QQVerionSstrings[7] & ".exe"
	ShellExecute($idmpath, '/n /q /d ' & $QQDURL & ' /p ' & $DownPath, @ScriptDir & "\New", "")
	IniWrite(@ScriptDir & "\CheckUp.Dat", "QQ", "url", $QQDURL)
EndIf

If $QQAndNew <> $QQAndOLD Then
	TrayTip("提示", "检查到 安卓QQ 正式版 最新版，新版开始下载......", 8, 1)
	Beep(600, 1000)

	ShellExecute($idmpath, '/n /q /d "http://sqdd.myapp.com/myapp/qqteam/AndroidQQ/Android_QQ.apk" /p ' & $DownPath, @ScriptDir & "\New", "")
	IniWrite(@ScriptDir & "\CheckUp.Dat", "QQ", "Android", $QQAndNew)
EndIf

If $QQAndINew <> $QQAndIOLD Then
	TrayTip("提示", "检查到 安卓QQ 国际版 最新版，新版开始下载......", 8, 1)
	Beep(600, 1000)

	ShellExecute($idmpath, '/n /q /d ' & $QQAndINew & ' /p ' & $DownPath, @ScriptDir & "\New", "")
	IniWrite(@ScriptDir & "\CheckUp.Dat", "QQ", "AndroidIntl", $QQAndINew)
EndIf

If $QQPCINew <> $QQPCIOLD Then
	TrayTip("提示", "检查到 PC QQ 国际版 最新版，新版开始下载......", 8, 1)
	Beep(600, 1000)

	ShellExecute($idmpath, '/n /q /d ' & $QQPCINew & ' /p ' & $DownPath, @ScriptDir & "\New", "")
	IniWrite(@ScriptDir & "\CheckUp.Dat", "QQ", "PCIntl", $QQPCINew)
EndIf

If $QQANDLiteNew <> $QQANDLiteOLD Then
	TrayTip("提示", "检查到 安卓QQ 轻聊版 最新版，新版开始下载......", 8, 1)
	Beep(600, 1000)

	ShellExecute($idmpath, '/n /q /d ' & $QQANDLiteNew & ' /p ' & $DownPath, @ScriptDir & "\New", "")
	IniWrite(@ScriptDir & "\CheckUp.Dat", "QQ", "AndroidLite", $QQANDLiteNew)
EndIf

If $OLDEditPlusDURL32 <> $EditPlusDURL32 Then
	TrayTip("提示", "检查到 EditPlus32位 最新版，新版开始下载......", 8, 1)
	Beep(600, 1000)
	If FileExists(@ScriptDir & "\New\EditPlus32.EXE") Then FileDelete(@ScriptDir & "\New\EditPlus32.EXE")
	ShellExecute($idmpath, '/n /q /d ' & $EditPlusDURL32 & ' /p ' & $DownPath & ' /f EditPlus32.EXE', @ScriptDir & "\New", "")
	IniWrite(@ScriptDir & "\CheckUp.Dat", "EditPlus", "url32", $EditPlusDURL32)
EndIf

If $OLDEditPlusDURL64 <> $EditPlusDURL64 Then
	TrayTip("提示", "检查到 EditPlus64 位最新版，新版开始下载......", 8, 1)
	Beep(600, 1000)
	If FileExists(@ScriptDir & "\New\EditPlus64.EXE") Then FileDelete(@ScriptDir & "\New\EditPlus64.EXE")
	ShellExecute($idmpath, '/n /q /d ' & $EditPlusDURL64 & ' /p ' & $DownPath & ' /f EditPlus64.EXE', @ScriptDir & "\New", "")
	IniWrite(@ScriptDir & "\CheckUp.Dat", "EditPlus", "url64", $EditPlusDURL64)
EndIf

If $OLDFlashFxpDURL <> $FlashFxpDURL Then
	TrayTip("提示", "检查到 FlashFxp 最新版，新版开始下载......", 8, 1)
	Beep(600, 1000)
	If FileExists(@ScriptDir & "\New\FlashFxp.EXE") Then FileDelete(@ScriptDir & "\New\FlashFxp.EXE")
	ShellExecute($idmpath, '/n /q /d ' & $FlashFxpDURL & ' /p ' & $DownPath & ' /f FlashFxp.EXE', @ScriptDir & "\New", "")
	IniWrite(@ScriptDir & "\CheckUp.Dat", "FlashFxp", "url", $FlashFxpDURL)
EndIf

If $OLDMp3TagDURL <> $Mp3TagDURL Then
	TrayTip("提示", "检查到 Mp3Tag 最新版，新版开始下载......", 8, 1)
	Beep(600, 1000)
	If FileExists(@ScriptDir & "\New\Mp3Tag.EXE") Then FileDelete(@ScriptDir & "\New\Mp3Tag.EXE")
	ShellExecute($idmpath, '/n /q /d ' & $Mp3TagDURL & ' /p ' & $DownPath & ' /f Mp3Tag.EXE', @ScriptDir & "\New", "")
	IniWrite(@ScriptDir & "\CheckUp.Dat", "Mp3Tag", "url", $Mp3TagDURL)
EndIf

If $OLDEmEditorDURL32 <> $EmEditorDURL32 Then
	TrayTip("提示", "检查到 EmEditor 32位 最新版，新版开始下载......", 8, 1)
	Beep(600, 1000)
	If FileExists(@ScriptDir & "\New\EmEditor32.EXE") Then FileDelete(@ScriptDir & "\New\EmEditor32.EXE")
	If FileExists(@ScriptDir & "\New\EmEditor32.zip") Then FileDelete(@ScriptDir & "\New\EmEditor32.zip")
	ShellExecute($idmpath, '/n /q /d ' & $EmEditorDURL32 & ' /p ' & $DownPath & ' /f EmEditor32.zip', @ScriptDir & "\New", "")
	IniWrite(@ScriptDir & "\CheckUp.Dat", "EmEditor", "url32", $EmEditorDURL32)
EndIf

If $OLDEmEditorDURL64 <> $EmEditorDURL64 Then
	TrayTip("提示", "检查到 EmEditor 64位 最新版，新版开始下载......", 8, 1)
	Beep(600, 1000)
	If FileExists(@ScriptDir & "\New\EmEditor64.EXE") Then FileDelete(@ScriptDir & "\New\EmEditor64.EXE")
	If FileExists(@ScriptDir & "\New\EmEditor64.zip") Then FileDelete(@ScriptDir & "\New\EmEditor64.zip")
	ShellExecute($idmpath, '/n /q /d ' & $EmEditorDURL64 & ' /p ' & $DownPath & ' /f EmEditor64.zip', @ScriptDir & "\New", "")
	IniWrite(@ScriptDir & "\CheckUp.Dat", "EmEditor", "url64", $EmEditorDURL64)
EndIf

If $FSCapture <> $OLDFSCapture Then
	TrayTip("提示", "检查到 FastStone Capture 最新版，新版开始下载......", 8, 1)
	Beep(600, 1000)
	If FileExists(@ScriptDir & "\New\FSCapture.zip") Then FileDelete(@ScriptDir & "\New\FSCapture.zip")
	ShellExecute($idmpath, '/n /q /d ' & $FSCapture & ' /p ' & $DownPath & ' /f FSCapture.zip', @ScriptDir & "\New", "")
	IniWrite(@ScriptDir & "\CheckUp.Dat", "FSCapture", "url", $FSCapture)
EndIf
If $GIFCAMNEWSIZE <> $GIFCAMOldSIZE Then
	TrayTip("提示", "检查到 GifCam 最新版，版本为：" & $GIFCAMNEWSIZE & "，新版开始下载......", 8, 1)
	Beep(600, 1000)
	If FileExists(@ScriptDir & "\New\GifCam.zip") Then FileDelete(@ScriptDir & "\New\GifCam.zip")
	ShellExecute($idmpath, '/n /q /d "http://www.bahraniapps.com/apps/gifcam/GifCam.zip" /p ' & $DownPath, @ScriptDir & "\New", "")
	IniWrite(@ScriptDir & "\CheckUp.Dat", "GIFCAM", "ver", $GIFCAMNEWSIZE)
EndIf
If $HyperSnapNEWSIZE <> $HyperSnapOldSIZE Then
	TrayTip("提示", "检查到 HyperSnap 最新版，开始调用IDM下载......", 8, 1)
	Beep(600, 1000)
	If FileExists(@ScriptDir & "\New\HS8Setup.exe") Then FileDelete(@ScriptDir & "\New\HS8Setup.exe")
	If FileExists(@ScriptDir & "\New\HS8Setup32.exe") Then FileDelete(@ScriptDir & "\New\HS8Setup32.exe")
	ShellExecute($idmpath, '/n /q /d "http://www.hyperionics.com/downloads/HS8Setup32.exe" /p ' & $DownPath, @ScriptDir & "\New", "")
	ShellExecute($idmpath, '/n /q /d "http://www.hyperionics.com/downloads/HS8Setup.exe" /p ' & $DownPath, @ScriptDir & "\New", "")
	IniWrite(@ScriptDir & "\CheckUp.Dat", "HyperSnap", "ver", $HyperSnapNEWSIZE)
EndIf

If $BeyondCompareDURL <> $OLDBeyondCompareDURL Then
	TrayTip("提示", "检查到 BeyondCompare 最新版，新版开始下载......", 8, 1)
	Beep(600, 1000)
	If FileExists(@ScriptDir & "\New\BeyondCompare-ZH.exe") Then FileDelete(@ScriptDir & "\New\BeyondCompare-ZH.exe")
	ShellExecute($idmpath, '/n /q /d ' & $BeyondCompareDURL & ' /p ' & $DownPath & ' /f BeyondCompare-ZH.exe', @ScriptDir & "\New", "")
	IniWrite(@ScriptDir & "\CheckUp.Dat", "BeyondCompare", "url", $BeyondCompareDURL)
EndIf

If $NewPowerISO <> $OLDPowerISO Then
	TrayTip("提示", "检查到 PowerISO 最新版，新版开始下载......", 8, 1)
	Beep(600, 1000)
	If FileExists(@ScriptDir & "\New\PowerISO6.exe") Then FileDelete(@ScriptDir & "\New\PowerISO6.exe")
	If FileExists(@ScriptDir & "\New\PowerISO6-x64.exe") Then FileDelete(@ScriptDir & "\New\PowerISO6-x64.exe")
	ShellExecute($idmpath, '/n /q /d "http://www.poweriso-files.com/PowerISO6.exe" /p ' & $DownPath, @ScriptDir & "\New", "")
	ShellExecute($idmpath, '/n /q /d "http://www.poweriso-files.com/PowerISO6-x64.exe" /p ' & $DownPath, @ScriptDir & "\New", "")
	IniWrite(@ScriptDir & "\CheckUp.Dat", "PowerISO", "size", $NewPowerISO)
EndIf

If $NewPicPick <> $OLDpicpick Then
	TrayTip("提示", "检查到 picpick 最新版，新版开始下载......", 8, 1)
	Beep(600, 1000)
	If FileExists(@ScriptDir & "\New\picpick_portable.zip") Then FileDelete(@ScriptDir & "\New\picpick_portable.zip")
	ShellExecute($idmpath, '/n /q /d "http://www.nteworks.com/latestdownload/picpick_portable.zip" /p ' & $DownPath, @ScriptDir & "\New", "")
	IniWrite(@ScriptDir & "\CheckUp.Dat", "picpick", "size", $NewPicPick)
EndIf

If $NewUltraISO <> $OLDUltraISO Then
	TrayTip("提示", "检查到 UltraISO 最新版，新版开始下载......", 8, 1)
	Beep(600, 1000)
	If FileExists(@ScriptDir & "\New\UltraISO_PE.exe") Then FileDelete(@ScriptDir & "\New\UltraISO_PE.exe")
	ShellExecute($idmpath, '/n /q /d "http://dw.ezbsys.net/uiso9_pe.exe" /p ' & $DownPath, @ScriptDir & "\New", "")
	IniWrite(@ScriptDir & "\CheckUp.Dat", "UltraISO", "size", $NewUltraISO)
EndIf

If $NewAliIM <> $OLDAliIM Then
	TrayTip("提示", "检查到 阿里旺旺买家版 最新版，新版开始下载......", 8, 1)
	Beep(600, 1000)
	If FileExists(@ScriptDir & "\New\AliIM.exe") Then FileDelete(@ScriptDir & "\New\AliIM.exe")
	ShellExecute($idmpath, '/n /q /d "http://download.wangwang.taobao.com/AliIm_taobao.php" /p ' & $DownPath, @ScriptDir & "\New", "")
	IniWrite(@ScriptDir & "\CheckUp.Dat", "AliIM", "size", $NewAliIM)
EndIf

If $NewcFos <> $OLDcFos Then
	TrayTip("提示", "检查到 cFosSpeed 正式版 最新版，新版开始下载......", 8, 1)
	Beep(600, 1000)
	ShellExecute($idmpath, '/n /q /d ' & $NewcFos & ' /p ' & $DownPath, @ScriptDir & "\New", "")
	IniWrite(@ScriptDir & "\CheckUp.Dat", "cFosSpeed", "url1", $NewcFos)
EndIf

If $NewcFosb <> $OLDcFosb Then
	TrayTip("提示", "检查到 cFosSpeed 测试版 最新版，新版开始下载......", 8, 1)
	Beep(600, 1000)
	ShellExecute($idmpath, '/n /q /d ' & $NewcFosb & ' /p ' & $DownPath, @ScriptDir & "\New", "")
	IniWrite(@ScriptDir & "\CheckUp.Dat", "cFosSpeed", "url2", $NewcFosb)
EndIf

If $New7star <> $OLD7star Then
	TrayTip("提示", "检查到 七星浏览器 最新版，新版开始下载......", 8, 1)
	Beep(600, 1000)
	ShellExecute($idmpath, '/n /q /d ' & $New7star & ' /p ' & $DownPath, @ScriptDir & "\New", "")
	IniWrite(@ScriptDir & "\CheckUp.Dat", "7star", "url", $New7star)
EndIf

If $Newcpuz <> $OLDcpuz Then
	TrayTip("提示", "检查到 CPU-Z 最新版，新版开始下载......", 8, 1)
	Beep(600, 1000)
	ShellExecute($idmpath, '/n /q /d ' & $Newcpuz & ' /p ' & $DownPath, @ScriptDir & "\New", "")
	IniWrite(@ScriptDir & "\CheckUp.Dat", "CPU-Z", "url", $Newcpuz)
EndIf

If $TeamViewerNEW <> $OLDTeamViewer Then
	TrayTip("提示", "检查到 TeamViewer 最新版，新版开始下载......", 8, 1)
	Beep(600, 1000)
	If FileExists(@ScriptDir & "\New\TeamViewerPortable.zip") Then FileDelete(@ScriptDir & "\New\TeamViewerPortable.zip")
	ShellExecute($idmpath, '/n /q /d "http://downloadap3.teamviewer.com/download/TeamViewerPortable.zip" /p ' & $DownPath, @ScriptDir & "\New", "")
	IniWrite(@ScriptDir & "\CheckUp.Dat", "TeamViewer", "size", $TeamViewerNEW)
EndIf

If $fdminstNEW <> $OLDfdminst Then
	TrayTip("提示", "检查到 FDM 最新版，新版开始下载......", 8, 1)
	Beep(600, 1000)
	If FileExists(@ScriptDir & "\New\fdminst.exe") Then FileDelete(@ScriptDir & "\New\fdminst.exe")
	ShellExecute($idmpath, '/n /q /d "http://f0.freedownloadmanager.org/fdminst.exe" /p ' & $DownPath, @ScriptDir & "\New", "")
	IniWrite(@ScriptDir & "\CheckUp.Dat", "fdminst", "size", $fdminstNEW)
EndIf

If $NewAudioShell <> $OLDAudioShell Then
	TrayTip("提示", "检查到 AudioShell 最新版，新版开始下载......", 8, 1)
	Beep(600, 1000)
	ShellExecute($idmpath, '/n /q /d ' & $NewAudioShell & ' /p ' & $DownPath, @ScriptDir & "\New", "")
	IniWrite(@ScriptDir & "\CheckUp.Dat", "AudioShell", "url", $NewAudioShell)
EndIf

If $Newdisktool <> $OLDdisktool Then
	TrayTip("提示", "检查到 分区助手 最新版，新版开始下载......", 8, 1)
	Beep(600, 1000)
	If FileExists(@ScriptDir & "\New\PAGreen.zip") Then FileDelete(@ScriptDir & "\New\PAGreen.zip")
	ShellExecute($idmpath, '/n /q /d "http://www.aomeisoftware.com/download/pacn/PAGreen.zip" /p ' & $DownPath, @ScriptDir & "\New", "")
	IniWrite(@ScriptDir & "\CheckUp.Dat", "disktool", "size", $Newdisktool)
EndIf

If $NewXnView <> $OLDXnView Then
	TrayTip("提示", "检查到 XnView " & $NewXnView & "，新版开始下载......", 8, 1)
	Beep(600, 1000)
	If FileExists(@ScriptDir & "\New\XnView-win.zip") Then FileDelete(@ScriptDir & "\New\XnView-win.zip")
	ShellExecute($idmpath, '/n /q /d "http://download.xnview.com/XnView-win.zip" /p ' & $DownPath, @ScriptDir & "\New", "")
	IniWrite(@ScriptDir & "\CheckUp.Dat", "XnView", "ver", $NewXnView)
EndIf

If $NewWinRAR <> $OLDWinRAR Then
	TrayTip("提示", "检查到 WinRAR英文版 最新版，新版开始下载......", 8, 1)
	Beep(600, 1000)
	ShellExecute($idmpath, '/n /q /d ' & $NewWinRAR32EngUrl & ' /p ' & $DownPath, @ScriptDir & "\New", "")
	ShellExecute($idmpath, '/n /q /d ' & $NewWinRAR64EngUrl & ' /p ' & $DownPath, @ScriptDir & "\New", "")
	IniWrite(@ScriptDir & "\CheckUp.Dat", "WinRAR", "EngVer", $NewWinRAR)
EndIf

If $NewWinRARC <> $OLDWinRARC Then
	TrayTip("提示", "检查到 WinRAR中文版 最新版，新版开始下载......", 8, 1)
	Beep(600, 1000)
	ShellExecute($idmpath, '/n /q /d ' & $NewWinRAR32ChnUrl & ' /p ' & $DownPath, @ScriptDir & "\New", "")
	ShellExecute($idmpath, '/n /q /d ' & $NewWinRAR64ChnUrl & ' /p ' & $DownPath, @ScriptDir & "\New", "")
	IniWrite(@ScriptDir & "\CheckUp.Dat", "WinRAR", "ChnVer", $NewWinRARC)
EndIf

If $OLDsandboxie32 <> $Newsandboxie32 Or $OLDsandboxie64 <> $Newsandboxie64 Then
	TrayTip("提示", "检查到 Sandboxie 最新版，新版开始下载......", 8, 1)
	Beep(600, 1000)
	ShellExecute($idmpath, '/n /q /d ' & $Newsandboxie32 & ' /p ' & $DownPath, @ScriptDir & "\New", "")
	ShellExecute($idmpath, '/n /q /d ' & $Newsandboxie64 & ' /p ' & $DownPath, @ScriptDir & "\New", "")
	IniWrite(@ScriptDir & "\CheckUp.Dat", "sandboxie", "url32", $Newsandboxie32)
	IniWrite(@ScriptDir & "\CheckUp.Dat", "sandboxie", "url64", $Newsandboxie64)
EndIf

If $NewAutoruns <> $OLDAutoruns Then
	TrayTip("提示", "检查到 Autoruns 最新版，新版开始下载......", 8, 1)
	Beep(600, 1000)
	If FileExists(@ScriptDir & "\New\Autoruns.zip") Then FileDelete(@ScriptDir & "\New\Autoruns.zip")
	ShellExecute($idmpath, '/n /q /d "https://download.sysinternals.com/files/Autoruns.zip" /p ' & $DownPath, @ScriptDir & "\New", "")
	IniWrite(@ScriptDir & "\CheckUp.Dat", "Autoruns", "date", $NewAutoruns)
EndIf

If $NewSystemExplorer <> $OLDSystemExplorer Then
	TrayTip("提示", "检查到 System Explorer 最新版，由于官网有防止盗链功能，下面打开浏览器进行下载......", 8, 1)
	Beep(600, 1000)
	Run(@ProgramFilesDir & "\Internet Explorer\iexplore.exe " & $NewSystemExplorer)
	IniWrite(@ScriptDir & "\CheckUp.Dat", "SystemExplorer", "url", $NewSystemExplorer)
EndIf

If $New7Zip32b <> $OLD7Zip32b Then
	TrayTip("提示", "检查到 7-Zip测试版 最新版，新版开始下载......", 8, 1)
	Beep(600, 1000)
	ShellExecute($idmpath, '/n /q /d ' & $New7Zip32b & ' /p ' & $DownPath, @ScriptDir & "\New", "")
	ShellExecute($idmpath, '/n /q /d ' & $New7Zip64b & ' /p ' & $DownPath, @ScriptDir & "\New", "")
	IniWrite(@ScriptDir & "\CheckUp.Dat", "7-Zip", "url32b", $New7Zip32b)
	IniWrite(@ScriptDir & "\CheckUp.Dat", "7-Zip", "url64b", $New7Zip64b)
EndIf

If $New7Zip32s <> $OLD7Zip32s Then
	TrayTip("提示", "检查到 7-Zip正式版 最新版，新版开始下载......", 8, 1)
	Beep(600, 1000)
	ShellExecute($idmpath, '/n /q /d ' & $New7Zip32s & ' /p ' & $DownPath, @ScriptDir & "\New", "")
	ShellExecute($idmpath, '/n /q /d ' & $New7Zip64s & ' /p ' & $DownPath, @ScriptDir & "\New", "")
	IniWrite(@ScriptDir & "\CheckUp.Dat", "7-Zip", "url32s", $New7Zip32s)
	IniWrite(@ScriptDir & "\CheckUp.Dat", "7-Zip", "url64s", $New7Zip64s)
EndIf

If $NEWThunderSP <> $OLDThunderSP Then
	TrayTip("提示", "检查到 迅雷极速版 最新版，新版开始下载......", 8, 1)
	Beep(600, 1000)
	ShellExecute($idmpath, '/n /q /d ' & $NEWThunderSP & ' /p ' & $DownPath, @ScriptDir & "\New", "")
	IniWrite(@ScriptDir & "\CheckUp.Dat", "ThunderSP", "url", $NEWThunderSP)
EndIf

If $NEWFSViewer <> $OLDFSViewer Then
	TrayTip("提示", "检查到 FastStone Image Viewer 最新版，新版开始下载......", 8, 1)
	Beep(600, 1000)
	ShellExecute($idmpath, '/n /q /d ' & $NEWFSViewer & ' /p ' & $DownPath, @ScriptDir & "\New", "")
	IniWrite(@ScriptDir & "\CheckUp.Dat", "FSViewer", "url", $NEWFSViewer)
EndIf

If $NEWNotepad2 <> $OLDNotepad2 Then
	TrayTip("提示", "检查到Notepad2-Mod 最新版，新版开始下载......", 8, 1)
	Beep(600, 1000)
	ShellExecute($idmpath, '/n /q /d ' & $NEWNotepad2 & ' /p ' & $DownPath, @ScriptDir & "\New", "")
	IniWrite(@ScriptDir & "\CheckUp.Dat", "Notepad2", "url", $NEWNotepad2)
EndIf

TrayTip("提示", "对比完成！程序退出！", 2, 1)
FileSetAttrib(@ScriptDir & "\CheckUp.Dat", "+R")
Sleep(1000)
Exit
