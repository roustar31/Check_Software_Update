#Region ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#AccAu3Wrapper_Icon=Windows Update.ico
#AccAu3Wrapper_OutFile=CheckUpDate.exe
#AccAu3Wrapper_UseUpx=Y
#AccAu3Wrapper_UseX64=n
#AccAu3Wrapper_Res_Comment=软件更新检查工具
#AccAu3Wrapper_Res_Description=软件更新检查工具
#AccAu3Wrapper_Res_Fileversion=1.5.2.5
#AccAu3Wrapper_Res_LegalCopyright=Copyright (c) 2015 睿派克技术论坛. All Rights Reserved.
#AccAu3Wrapper_Res_SaveSource=y
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=requireAdministrator
#AccAu3Wrapper_Res_Field=OriginalFilename|软件更新检查工具
#AccAu3Wrapper_Res_Field=ProductName|软件更新检查工具
#AccAu3Wrapper_Res_Field=ProductVersion|1.5.2.5
#AccAu3Wrapper_Res_Field=InternalName|软件更新检查工具
#AccAu3Wrapper_Res_Field=FileDescription|自动检查软件更新
#AccAu3Wrapper_Res_Field=Comments|自动检查软件更新的工具
#AccAu3Wrapper_Res_Field=LegalTrademarks|睿派克技术论坛
#AccAu3Wrapper_Res_Field=CompanyName|睿派克技术论坛
#AccAu3Wrapper_Res_Field=PowerBy|睿派克技术论坛
#AccAu3Wrapper_Res_Field=Design|roustar31
#AccAu3Wrapper_Res_Field=SourceCode|roustar31
#AccAu3Wrapper_Run_Tidy=Y
#AccAu3Wrapper_Antidecompile=y
#EndRegion ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#Region ;**** 参数创建于 ACNWrapper_GUI ****
#EndRegion ;**** 参数创建于 ACNWrapper_GUI ****
Opt("TrayMenuMode", 1)
#include <Array.au3>
#include <INet.au3>
#include <Process.au3>
#include <File.au3>
#include <IE.au3>
$DataFile = @ScriptDir & "\CheckUp.Dat"
$DownPath = @ScriptDir & "\New"
;HttpSetProxy(2, "127.0.0.1:1080")
HttpSetUserAgent("Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/44.0.2403.125 Safari/537.36")
Local $aPid = ProcessList(@ScriptName)
If Not IsArray($aPid) Then Exit
For $i = 1 To $aPid[0][0]
	If $aPid[$i][1] == @AutoItPID Then ContinueLoop
	Exit
Next
TrayTip("提示", "判断联网状态中.......", 3, 1)
Local $Net1 = _RunDos("ping -n 1 -w 2000 www.baidu.com||exit 303")
Local $Net2 = _RunDos("ping -n 1 -w 2000 www.sina.cn||exit 303")
If $Net1 = "303" And $Net2 = "303" Then
	TrayTip("提示", "貌似没有联网，程序退出.......", 3, 1)

	Exit
EndIf
If Not FileExists(@ScriptDir & "\CheckUp.Dat") Then Exit
FileSetAttrib(@ScriptDir & "\CheckUp.Dat", "-HSR")
$taskcheck = IniRead(@ScriptDir & "\CheckUp.Dat", "Task", "ok", "1")
If $taskcheck = "0" Then
	TrayTip("提示", "检测到还没有注册为任务计划，注册为计划任务中......." & @CRLF & "如果注册不成功，请退出程序后右键使用管理员身份运行", 3, 1)
	RunWait(@ComSpec & ' /c ' & 'schtasks /create /sc minute /mo 25 /tn "检查软件更新" /tr ' & @AutoItExe)
	IniWrite(@ScriptDir & "\CheckUp.Dat", "Task", "ok", "1")
EndIf
TrayTip("提示", "读取本地版本中.......", 3, 1)
FileDelete(@ScriptDir & "\checkup.ini")
$idmpath = RegRead("HKEY_CURRENT_USER\Software\DownloadManager", "ExePath")
If $idmpath = "" Then
	$idmpath = IniRead(@ScriptDir & "\CheckUp.Dat", "IDMExePath", "Path", "")
	If $idmpath = "" Then
		MsgBox(64 + 0, "抱歉", "程序没有检测到IDM可执行程序！" & "建议安装IDM后再次重试！", 35)
		Exit
	EndIf
EndIf
If Not FileExists($DownPath) Then DirCreate($DownPath)
$OLDvirtualbox = IniRead($DataFile, "virtualbox", "url", "")
$OLDClassicShell = IniRead($DataFile, "ClassicShell", "url", "")
$OLDDictionary = IniRead($DataFile, "Dictionary", "size", "")
$OLDStartIsBack = IniRead($DataFile, "StartIsBack", "size", "")
$OLDhoneyview = IniRead($DataFile, "honeyview", "size", "")
$honeyviewcheck = IniRead($DataFile, "honeyview", "check", "1")
$OLDbandizip = IniRead($DataFile, "bandizip", "size", "")
$bandizipcheck = IniRead($DataFile, "bandizip", "check", "1")
$OLDbandicam = IniRead($DataFile, "bandicam", "size", "")
$bandicamcheck = IniRead($DataFile, "bandicam", "check", "1")
$OLDUltraEdit = IniRead($DataFile, "UltraEdit", "size", "")
$UltraEditcheck = IniRead($DataFile, "UltraEdit", "check", "1")
$OLDBaidumusic = IniRead($DataFile, "Baidumusic", "url", "")
$Baidumusiccheck = IniRead($DataFile, "Baidumusic", "check", "1")
$OLDEverythingx86 = IniRead($DataFile, "Everything", "url1", "")
$Everythingcheck = IniRead($DataFile, "Everything", "check", "1")
$OLDEverythingx64 = IniRead($DataFile, "Everything", "url2", "")
$OLDFlashPlayer = IniRead($DataFile, "FlashPlayer", "size", "")
$FlashPlayercheck = IniRead($DataFile, "FlashPlayer", "check", "1")
$OLDVMWare = IniRead($DataFile, "VMWare", "size", "")
$VMWareCheck = IniRead($DataFile, "VMWare", "check", "1")
$OLDSSDZ = IniRead($DataFile, "SSDZ", "url", "")
$OLDSSDZCheck = IniRead($DataFile, "SSDZ", "check", "0")
$OLDWinContig = IniRead($DataFile, "WinContig", "ver", "")
$OLDAIDA64 = IniRead($DataFile, "AIDA64", "url", "")
$OLDNotepad2 = IniRead($DataFile, "Notepad2", "url", "")
$OLDFoxitreader = IniRead($DataFile, "Foxitreader", "time", "")
$OLDThunderSP = IniRead($DataFile, "ThunderSP", "url", "")
$OLDSystemExplorer = IniRead($DataFile, "SystemExplorer", "size", "")
$OLDAutoruns = IniRead($DataFile, "Autoruns", "date", "")
$OLD7Zip32b = IniRead($DataFile, "7-Zip", "url32b", "")
$OLD7Zip64b = IniRead($DataFile, "7-Zip", "url64b", "")
$OLD7Zip32s = IniRead($DataFile, "7-Zip", "url32s", "")
$OLD7Zip64s = IniRead($DataFile, "7-Zip", "url64s", "")
$OLDsandboxie32 = IniRead($DataFile, "sandboxie", "url32", "")
$OLDsandboxie64 = IniRead($DataFile, "sandboxie", "url64", "")
$OLDWinRAR = IniRead($DataFile, "WinRAR", "EngVer", "")
$OLDWinRARC = IniRead($DataFile, "WinRAR", "ChnVer", "")
$OLDXnView = IniRead($DataFile, "XnView", "ver", "")
$OLDdisktool = IniRead($DataFile, "disktool", "size", "")
$OLDAudioShell = IniRead($DataFile, "AudioShell", "url", "")
$OLDfdminst = IniRead($DataFile, "fdminst", "size", "")
$OLDTeamViewer = IniRead($DataFile, "TeamViewer", "size", "")
$OLDcpuz = IniRead($DataFile, "CPU-Z", "url", "")
$OLD7star = IniRead($DataFile, "7star", "url", "")
$OLDcFos = IniRead($DataFile, "cFosSpeed", "url1", "")
$OLDcFosb = IniRead($DataFile, "cFosSpeed", "url2", "")
$OLDAliIM = IniRead($DataFile, "AliIM", "size", "")
$AliIMcheck = IniRead($DataFile, "AliIM", "check", "0")
$OLDpicpick = IniRead($DataFile, "picpick", "size", "")
$OLDUltraISO = IniRead($DataFile, "UltraISO", "size", "")
$OLDPowerISO = IniRead($DataFile, "PowerISO", "size", "")
$OLDBeyondCompareDURL = IniRead($DataFile, "BeyondCompare", "url", "")
$OLDccleaner = IniRead($DataFile, "ccleaner", "ver", "")
$OLDrecuva = IniRead($DataFile, "recuva", "ver", "")
$OLDdefraggler = IniRead($DataFile, "defraggler", "ver", "")
$OLDspeccy = IniRead($DataFile, "speccy", "ver", "")
$OLDDGDURL = IniRead($DataFile, "DG", "url", "")
$OLDWPSDURL = IniRead($DataFile, "WPS", "url1", "")
$OLDWPSDURL2 = IniRead($DataFile, "WPS", "url2", "")
$OLDWinSnapDURL = IniRead($DataFile, "WinSnap", "url", "")
$OLDFSCapture = IniRead($DataFile, "FSCapture", "url", "")
$OLDFSViewer = IniRead($DataFile, "FSViewer", "url", "")
$OLDFSResizer = IniRead($DataFile, "FSResizer", "url", "")
$OLDEmEditorDURL32 = IniRead($DataFile, "EmEditor", "url32", "")
$OLDEmEditorDURL64 = IniRead($DataFile, "EmEditor", "url64", "")
$OLDTagScannerDURL = IniRead($DataFile, "TagScanner", "url", "")
$OLDIDMDURL = IniRead($DataFile, "IDM", "url", "")
$OLDPPTVDURL = IniRead($DataFile, "PPTV", "url", "")
$OLDQQDURL = IniRead($DataFile, "QQ", "url", "")
$QQAndOLD = IniRead($DataFile, "QQ", "Android", "")
$QQAndIOLD = IniRead($DataFile, "QQ", "AndroidIntl", "")
$QQANDLiteOLD = IniRead($DataFile, "QQ", "AndroidLite", "")
$QQPCIOLD = IniRead($DataFile, "QQ", "PCIntl", "")
$QQPCLiteOLD = IniRead($DataFile, "QQ", "PCLite", "")
$OLDMp3TagDURL = IniRead($DataFile, "Mp3Tag", "url", "")
$OLDFlashFxpDURL = IniRead($DataFile, "FlashFxp", "url", "")
$OLDEditPlusDURL32 = IniRead($DataFile, "EditPlus", "url32", "")
$OLDEditPlusDURL64 = IniRead($DataFile, "EditPlus", "url64", "")
$OldVersion = IniRead($DataFile, "luckPath", "verion", "")
$KGOldVerion = IniRead($DataFile, "kugou", "verion", "")
$PTOldSIZE = IniRead($DataFile, "pot", "size", "")
$PTOldSIZE1 = IniRead($DataFile, "pot", "size1", "")
$163MUSICOldSIZE = IniRead($DataFile, "163music", "size", "")
$GIFCAMOldSIZE = IniRead($DataFile, "GIFCAM", "ver", "")
$HyperSnapOldSIZE = IniRead($DataFile, "HyperSnap", "ver", "")
$KGDownUrl = "http://downmini.kugou.com/kugou"
$LKDownUrl = "http://chelpus.defcon5.biz/LuckyPatcher.apk"
$LKPathLogsUrl = "http://chelpus.defcon5.biz/Changelogs.txt"
$greenifyURL = "http://oasisfeng.com/Greenify.apk"
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
TrayTip("提示", "开始检查 AIDA64 更新......", 3, 1)
$AIDA64Surls = _INetGetSource("http://www.aida64.com/downloads/latesta64xe")
If @error Then
	$NEWAIDA64 = $OLDAIDA64
Else
	$AIDA64Vs = StringRegExp($AIDA64Surls, '(http://download.aida64.com/aida64extreme.+?exe)', 3)
	If @error Or $AIDA64Vs = "1" Then
		$NEWAIDA64 = $OLDAIDA64
	Else
		$NEWAIDA64 = StringReplace($AIDA64Vs[0], ".exe", ".zip", 0, 0)
	EndIf
EndIf
TrayTip("提示", "开始检查 WinContig 更新......", 3, 1)
$WinContigSurls = _INetGetSource("http://wincontig.mdtzone.it/en/history.htm")
If @error Then
	$NEWWinContig = $OLDWinContig
Else
	$WinContigVs = StringRegExp($WinContigSurls, '(What.+?:)', 3)
	If @error Or $WinContigVs = "1" Then
		$NEWWinContig = $OLDWinContig
	Else
		$NEWWinContig = StringTrimRight(StringTrimLeft(StringStripWS($WinContigVs[0], 8), 18), 1)
	EndIf
EndIf
TrayTip("提示", "开始检查 SSD-Z 更新......", 3, 1)
$SSDZSurls = _INetGetSource("http://aezay.dk/aezay/ssdz/")
If @error Then
	$NEWSSDZ = $OLDSSDZ
Else
	$SSDZVs = StringRegExp($SSDZSurls, '(SSD-Z_.+?.rar)', 3)
	If @error Or $SSDZVs = "1" Then
		$NEWSSDZ = $OLDSSDZ
	Else
		$NEWSSDZ = "http://aezay.dk/aezay/ssdz/" & $SSDZVs[0]
	EndIf
EndIf
TrayTip("提示", "开始检查 Everything 更新......", 3, 1)
$EverythingSurls = _INetGetSource("http://www.voidtools.com/downloads")
If @error Then
	$NEWEverythingx86 = $OLDEverythingx86
	$NEWEverythingx64 = $OLDEverythingx64
Else
	$EverythingVs = StringRegExp($EverythingSurls, '(http://www.voidtools.com/Everything-.+?.Multilingual.zip)', 3)
	If @error Or $EverythingVs = "1" Then
		$NEWEverythingx86 = $OLDEverythingx86
		$NEWEverythingx64 = $OLDEverythingx64
	Else
		$NEWEverythingx86 = $EverythingVs[0]
		$NEWEverythingx64 = $EverythingVs[1]
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
TrayTip("提示", "开始检查 Foxit Reader 更新......", 3, 1)
$FoxitReaderSurl = _INetGetSource("http://cdn01.foxitsoftware.com/pub/foxit/reader/desktop/win/7.x/")
If @error Then
	$NEWFoxitreader = $OLDFoxitreader
Else
	$FoxitReaderSurl2 = StringRegExp($FoxitReaderSurl, '(</a></td><td align="right">.+?</td>)', 3)
	If @error Or $FoxitReaderSurl2 = "1" Then
		$NEWFoxitreader = $OLDFoxitreader
	Else
		$NEWFoxitreader = StringTrimRight(StringTrimLeft($FoxitReaderSurl2[1], 27), 7)
	EndIf
EndIf
TrayTip("提示", "开始检查 DiskGenius 更新......", 3, 1)
$DGSurls = _INetGetSource("http://www.diskgenius.cn/download.php")
If @error Then
	$DGDURL = $OLDDGDURL
Else
	$DGVs = StringRegExp($DGSurls, '(http://download.eassos.cn/DG.+?zip)', 3)
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
If $AliIMcheck <> "0" Then
	$NewAliIM = InetGetSize("http://download.wangwang.taobao.com/AliIm_taobao.php")
	If @error Or $NewAliIM = "0" Then
		$NewAliIM = $OLDAliIM
	EndIf
EndIf
If $AliIMcheck = "0" Then $NewAliIM = $OLDAliIM
TrayTip("提示", "开始检查 Adobe Flash Player 更新......", 3, 1)
$NewFlashPlayer = InetGetSize("http://fpdownload.macromedia.com/pub/flashplayer/latest/help/install_flash_player_ax.exe")
If @error Or $NewFlashPlayer = "0" Then
	$NewFlashPlayer = $OLDFlashPlayer
EndIf
TrayTip("提示", "开始检查 VMware Workstation 更新......", 3, 1)
$NewVMWare = InetGetSize("http://www.vmware.com/go/tryworkstation-win")
If @error Or $NewVMWare = "0" Then
	$NewVMWare = $OLDVMWare
EndIf
;------------------阿里旺旺买家版 检查结束----------------------
TrayTip("提示", "开始检查 PotPlayer 更新......", 3, 1)
$POTDownUrl = "http://117.52.4.235/beta/PotPlayerSetup.exe"
$POTDownUrl1 = "http://get.daum.net/PotPlayer/v3/PotPlayerSetup.exe"
$PTNEWSIZE = InetGetSize($POTDownUrl, 1)
If @error Or $PTNEWSIZE = "0" Then
	$PTNEWSIZE = $PTOldSIZE
EndIf
$PTNEWSIZE1 = InetGetSize($POTDownUrl1, 1)
If @error Or $PTNEWSIZE1 = "0" Then
	$PTNEWSIZE1 = $PTOldSIZE1
EndIf
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
;------------------FastStone Photo Resizer检查结束----------------------
TrayTip("提示", "开始检查  FastStone Photo Resizer 更新......", 3, 1)
$FSResizerSurls = _INetGetSource("http://www.faststone.org/FSResizerDownload.htm")
If @error Then
	$NEWFSResizer = $OLDFSResizer
Else
	$FSResizers = StringRegExp($FSResizerSurls, '(http://www.faststonesoft.net/DN/FSResizer.+?zip)', 3)
	If @error Then $NEWFSResizer = $OLDFSResizer
	$NEWFSResizer = $FSResizers[1]
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
	$cpuzurls1 = StringRegExp($cpuzurls, '(/cpu-z/cpu-z_.+?cn.zip)', 3)
	If @error Or $cpuzurls1 = "1" Then
		$Newcpuz = $OLDcpuz
	Else
		$Newcpuz = 'ftp://ftp.cpuid.com' & $cpuzurls1[0]
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
$NewSystemExplorer = InetGetSize("http://systemexplorer.net/download/SystemExplorerSetup.exe")
If @error Then
	$NewSystemExplorer = $OLDSystemExplorer
EndIf
TrayTip("提示", "开始检查 百度音乐 更新......", 3, 1)
$BaiduMSurls = _INetGetSource("http://music.baidu.com/pc/index.html")
If @error Then
	$NEWBaidumusic = $OLDBaidumusic
Else
	$BaiduMVs = StringRegExp($BaiduMSurls, '(id="bdLink".+?.exe)', 3)
	If @error Or $BaiduMVs = "1" Then
		$NEWBaidumusic = $OLDBaidumusic
	Else
		$NEWBaidumusic = "http://music.baidu.com" & StringTrimLeft($BaiduMVs[0], 32)
	EndIf
EndIf

TrayTip("提示", "开始检查 UltraEdit 更新......", 3, 1)
$NewUltraEdit = InetGetSize("http://www.ultraedit.com/files/ue_chinese.exe", 1)
If @error Or $NewUltraEdit = "0" Then
	$NewUltraEdit = $OLDUltraEdit
EndIf

TrayTip("提示", "开始检查 bandizip 更新......", 3, 1)
$Newbandizip = InetGetSize("http://down.bandisoft.com/bandizip/BANDIZIP-SETUP.EXE", 1)
If @error Or $Newbandizip = "0" Then
	$Newbandizip = $OLDbandizip
EndIf

TrayTip("提示", "开始检查 StartIsBack 更新......", 3, 1)
$NewStartIsBack = InetGetSize("https://s3.amazonaws.com/startisback/StartIsBackPlusPlus_setup.exe", 1)
If @error Or $NewStartIsBack = "0" Then
	$NewStartIsBack = $OLDStartIsBack
EndIf

TrayTip("提示", "开始检查 Dictionary 更新......", 3, 1)
$NewDictionary = InetGetSize("http://fishcodelib.com/files/DictionaryNet.zip", 1)
If @error Or $NewDictionary = "0" Then
	$NewDictionary = $OLDDictionary
EndIf

TrayTip("提示", "开始检查 bandicam 更新......", 3, 1)
$Newbandicam = InetGetSize("http://ca-dl.bandicam.com/bdcamsetup.exe", 1)
If @error Or $Newbandicam = "0" Then
	$Newbandicam = $OLDbandicam
EndIf

TrayTip("提示", "开始检查 honeyview 更新......", 3, 1)
$Newhoneyview = InetGetSize("http://down.bandisoft.com/honeyview/HONEYVIEW-SETUP.EXE", 1)
If @error Or $Newhoneyview = "0" Then
	$Newhoneyview = $OLDhoneyview
EndIf

TrayTip("提示", "开始检查 Classic Shell 更新......", 3, 1)
$ClassicShellSurls = _INetGetSource("http://www.classicshell.net")
If @error Then
	$NEWClassicShell = $OLDClassicShell
Else
	$ClassicShellVs = StringRegExp($ClassicShellSurls, '(http://www.fosshub.com/Classic-Shell.html.+?exe)', 3)
	If @error Or $ClassicShellVs = "1" Then
		$NEWClassicShell = $OLDClassicShell
	Else
		$NEWClassicShell = $ClassicShellVs[0]
	EndIf
EndIf

TrayTip("提示", "开始检查 virtualbox 更新......", 3, 1)
$virtualboxSurls = _INetGetSource("https://www.virtualbox.org/wiki/Downloads")
If @error Then
	$NEWvirtualbox = $OLDvirtualbox
Else
	$virtualboxVs = StringRegExp($virtualboxSurls, '(http://download.virtualbox.org/virtualbox.+?win.exe)', 3)
	If @error Or $virtualboxVs = "1" Then
		$NEWvirtualbox = $OLDvirtualbox
	Else
		$NEWvirtualbox = $virtualboxVs[0]
	EndIf
EndIf

TrayTip("提示", "所有软件更新检查完毕！开始对比版本......", 3, 1)
Sleep(1000)
If $NewVersion <> $OldVersion Then
	TrayTip("提示", "检查到 LuckyPatcher 最新版，版本为：" & $NewVersion & "开始下载......", 8, 1)
	Beep(600, 1000)
	If FileExists(@ScriptDir & "\New\LuckyPatcher.apk") Then FileDelete(@ScriptDir & "\New\LuckyPatcher.apk")
	ShellExecute($idmpath, '/n /d ' & $LKDownUrl & ' /p ' & $DownPath & ' /f LuckyPatcher.apk', @ScriptDir & "\New", "")
	Sleep(1000)
	IniWrite($DataFile, "luckPath", "verion", $NewVersion)
EndIf
FileClose($NewVersion)
If $KGIfNew <> 0 Then
	TrayTip("提示", "检查到 酷狗 最新版，版本为：" & $KGNewVerion & "开始下载......", 8, 1)
	Beep(600, 1000)
	$NewkugouUrl = $KGDownUrl & $KGNewVerion & ".exe"
	ShellExecute($idmpath, '/n /d ' & $NewkugouUrl & ' /p ' & $DownPath, @ScriptDir & "\New", "")
	Sleep(1000)
	IniWrite($DataFile, "kugou", "verion", $KGNewVerion)
EndIf
If $PTNEWSIZE <> $PTOldSIZE Then
	TrayTip("提示", "检查到 PotPlayer 测试版 最新版，新版大小为：" & $PTNEWSIZE & "开始下载......", 8, 1)
	Beep(600, 1000)
	If FileExists(@ScriptDir & "\New\PotPlayerSetupbeta.exe") Then FileDelete(@ScriptDir & "\New\PotPlayerSetupbeta.exe")
	ShellExecute($idmpath, '/n /d ' & $POTDownUrl & ' /p ' & $DownPath & ' /f PotPlayerSetupbeta.exe', @ScriptDir & "\New", "")
	Sleep(1000)
	IniWrite($DataFile, "pot", "size", $PTNEWSIZE)
EndIf
If $PTNEWSIZE1 <> $PTOldSIZE1 Then
	TrayTip("提示", "检查到 PotPlayer 测试版 最新版，新版大小为：" & $PTNEWSIZE1 & "开始下载......", 8, 1)
	Beep(600, 1000)
	If FileExists(@ScriptDir & "\New\PotPlayerSetup.exe") Then FileDelete(@ScriptDir & "\New\PotPlayerSetup.exe")
	ShellExecute($idmpath, '/n /d ' & $POTDownUrl1 & ' /p ' & $DownPath & ' /f PotPlayerSetup.exe', @ScriptDir & "\New", "")
	Sleep(1000)
	IniWrite($DataFile, "pot", "size1", $PTNEWSIZE1)
EndIf
If $163MUSICNEWSIZE <> $163MUSICOldSIZE Then
	TrayTip("提示", "检查到 网易云音乐 正式版 最新版，新版大小为：" & $163MUSICNEWSIZE & "开始下载......", 8, 1)
	Beep(600, 1000)
	If FileExists(@ScriptDir & "\New\163music.exe") Then FileDelete(@ScriptDir & "\New\163music.exe")
	ShellExecute($idmpath, '/n /d "http://music.163.com/api/pc/download/latest" /p ' & $DownPath & ' /f 163music.exe', @ScriptDir & "\New", "")
	Sleep(1000)
	IniWrite($DataFile, "163music", "size", $163MUSICNEWSIZE)
EndIf
If $OLDIDMDURL <> $IDMDURL Then
	TrayTip("提示", "检查到 IDM 最新版，新版开始下载......", 8, 1)
	Beep(600, 1000)
	If FileExists(@ScriptDir & "\New\IDM.exe") Then FileDelete(@ScriptDir & "\New\IDM.exe")
	ShellExecute($idmpath, '/n /d ' & $IDMDURL & ' /p ' & $DownPath & ' /f IDM.EXE', @ScriptDir & "\New", "")
	Sleep(1000)
	IniWrite($DataFile, "IDM", "url", $IDMDURL)
EndIf
If $OLDPPTVDURL <> $PPTVDURL Then
	TrayTip("提示", "检查到 PPTV 最新版，新版开始下载......", 8, 1)
	Beep(600, 1000)
	If FileExists(@ScriptDir & "\New\PPTV.exe") Then FileDelete(@ScriptDir & "\New\PPTV.exe")
	ShellExecute($idmpath, '/n /d ' & $PPTVDURL & ' /p ' & $DownPath & ' /f PPTV.EXE', @ScriptDir & "\New", "")
	Sleep(1000)
	IniWrite($DataFile, "PPTV", "url", $PPTVDURL)
EndIf
If $OLDWinSnapDURL <> $WinSnapDURL Then
	TrayTip("提示", "检查到 WinSnap 最新版，新版开始下载......", 8, 1)
	Beep(600, 1000)
	If FileExists(@ScriptDir & "\New\WinSnap.exe") Then FileDelete(@ScriptDir & "\New\WinSnap.exe")
	ShellExecute($idmpath, '/n /d ' & $WinSnapDURL & ' /p ' & $DownPath & ' /f WinSnap.EXE', @ScriptDir & "\New", "")
	Sleep(1000)
	IniWrite($DataFile, "WinSnap", "url", $WinSnapDURL)
EndIf
If $OLDWPSDURL2 <> $WPSDURL2 Then
	TrayTip("提示", "检查到 WPS 正式版 最新版，新版开始下载......", 8, 1)
	Beep(600, 1000)
	If FileExists(@ScriptDir & "\New\WPS.exe") Then FileDelete(@ScriptDir & "\New\WPS.exe")
	ShellExecute($idmpath, '/n /d ' & $WPSDURL2 & ' /p ' & $DownPath & ' /f WPS.exe', @ScriptDir & "\New", "")
	Sleep(1000)
	IniWrite($DataFile, "WPS", "url2", $WPSDURL2)
EndIf
If $OLDWPSDURL <> $WPSDURL Then
	TrayTip("提示", "检查到 WPS 抢鲜版 最新版，新版开始下载......", 8, 1)
	Beep(600, 1000)
	If FileExists(@ScriptDir & "\New\WPSBeta.exe") Then FileDelete(@ScriptDir & "\New\WPSBeta.exe")
	ShellExecute($idmpath, '/n /d ' & $WPSDURL & ' /p ' & $DownPath & ' /f WPSBeta.exe', @ScriptDir & "\New", "")
	Sleep(1000)
	IniWrite($DataFile, "WPS", "url1", $WPSDURL)
EndIf
If $OLDDGDURL <> $DGDURL Then
	TrayTip("提示", "检查到 DiskGenius 最新版，由于官网有防盗链，下面打开浏览器自行下载......", 8, 1)
	Beep(600, 1000)
	ShellExecute("http://www.diskgenius.cn/download.php")
	IniWrite($DataFile, "DG", "url", $DGDURL)
EndIf
If $OLDccleaner <> $ccleanerDURL Then
	TrayTip("提示", "检查到 CCleaner 最新版" & $ccleanerDURL & "，新版开始下载......", 8, 1)
	Beep(600, 1000)
	$ccleanerDURL2 = StringSplit($ccleanerDURL, ".")
	$ccleanerDURL3 = "http://download.piriform.com/ccsetup" & $ccleanerDURL2[1] & $ccleanerDURL2[2] & "pro.exe"
	ShellExecute($idmpath, '/n /d ' & $ccleanerDURL3 & ' /p ' & $DownPath & ' /f ccsetuppro.exe', @ScriptDir & "\New", "")
	Sleep(1000)
	IniWrite($DataFile, "ccleaner", "ver", $ccleanerDURL)
EndIf
If $OLDspeccy <> $speccyDURL Then
	TrayTip("提示", "检查到 Speccy 最新版" & $speccyDURL & "，新版开始下载......", 8, 1)
	Beep(600, 1000)
	$speccyDURL2 = StringSplit($speccyDURL, ".")
	$speccyDURL3 = "http://download.piriform.com/spsetup" & $speccyDURL2[1] & $speccyDURL2[2] & ".exe"
	ShellExecute($idmpath, '/n /d ' & $speccyDURL3 & ' /p ' & $DownPath, @ScriptDir & "\New", "")
	Sleep(1000)
	IniWrite($DataFile, "speccy", "ver", $speccyDURL)
EndIf
If $OLDrecuva <> $recuvaDURL Then
	TrayTip("提示", "检查到 Recuva 最新版" & $recuvaDURL & "，新版开始下载......", 8, 1)
	Beep(600, 1000)
	$recuvaDURL2 = StringSplit($recuvaDURL, ".")
	$recuvaDURL3 = "http://download.piriform.com/rcsetup" & $recuvaDURL2[1] & $recuvaDURL2[2] & ".exe"
	ShellExecute($idmpath, '/n /d ' & $recuvaDURL3 & ' /p ' & $DownPath, @ScriptDir & "\New", "")
	Sleep(1000)
	IniWrite($DataFile, "recuva", "ver", $recuvaDURL)
EndIf
If $OLDdefraggler <> $defragglerDURL Then
	TrayTip("提示", "检查到 Defraggler 最新版" & $defragglerDURL & "，新版开始下载......", 8, 1)
	Beep(600, 1000)
	$defragglerDURL2 = StringSplit($defragglerDURL, ".")
	$defragglerDURL3 = "http://download.piriform.com/dfsetup" & $defragglerDURL2[1] & $defragglerDURL2[2] & ".exe"
	ShellExecute($idmpath, '/n /d ' & $defragglerDURL3 & ' /p ' & $DownPath, @ScriptDir & "\New", "")
	Sleep(1000)
	IniWrite($DataFile, "defraggler", "ver", $defragglerDURL)
EndIf
If $OLDTagScannerDURL <> $TagScannerDURL Then
	TrayTip("提示", "检查到 TagScanner 最新版，新版开始下载......", 8, 1)
	Beep(600, 1000)
	If FileExists(@ScriptDir & "\New\TagScanner.zip") Then FileDelete(@ScriptDir & "\New\TagScanner.zip")
	ShellExecute($idmpath, '/n /d ' & $TagScannerDURL & ' /p ' & $DownPath, @ScriptDir & "\New", "")
	Sleep(1000)
	IniWrite($DataFile, "TagScanner", "url", $TagScannerDURL)
EndIf
If $OLDQQDURL <> $QQDURL Then
	TrayTip("提示", "检查到 PC QQ 正式版 最新版，新版开始下载......", 8, 1)
	Beep(600, 1000)
	Local $QQFileName = $QQVerionSstrings[6] & "." & $QQVerionSstrings[7] & ".exe"
	ShellExecute($idmpath, '/n /d ' & $QQDURL & ' /p ' & $DownPath, @ScriptDir & "\New", "")
	Sleep(1000)
	IniWrite($DataFile, "QQ", "url", $QQDURL)
EndIf
If $QQAndNew <> $QQAndOLD Then
	TrayTip("提示", "检查到 安卓QQ 正式版 最新版，新版开始下载......", 8, 1)
	Beep(600, 1000)
	ShellExecute($idmpath, '/n /d "http://sqdd.myapp.com/myapp/qqteam/AndroidQQ/Android_QQ.apk" /p ' & $DownPath, @ScriptDir & "\New", "")
	Sleep(1000)
	IniWrite($DataFile, "QQ", "Android", $QQAndNew)
EndIf
If $QQAndINew <> $QQAndIOLD Then
	TrayTip("提示", "检查到 安卓QQ 国际版 最新版，新版开始下载......", 8, 1)
	Beep(600, 1000)
	ShellExecute($idmpath, '/n /d ' & $QQAndINew & ' /p ' & $DownPath, @ScriptDir & "\New", "")
	Sleep(1000)
	IniWrite($DataFile, "QQ", "AndroidIntl", $QQAndINew)
EndIf
If $QQPCINew <> $QQPCIOLD Then
	TrayTip("提示", "检查到 PC QQ 国际版 最新版，新版开始下载......", 8, 1)
	Beep(600, 1000)
	ShellExecute($idmpath, '/n /d ' & $QQPCINew & ' /p ' & $DownPath, @ScriptDir & "\New", "")
	Sleep(1000)
	IniWrite($DataFile, "QQ", "PCIntl", $QQPCINew)
EndIf
If $QQANDLiteNew <> $QQANDLiteOLD Then
	TrayTip("提示", "检查到 安卓QQ 轻聊版 最新版，新版开始下载......", 8, 1)
	Beep(600, 1000)
	ShellExecute($idmpath, '/n /d ' & $QQANDLiteNew & ' /p ' & $DownPath, @ScriptDir & "\New", "")
	Sleep(1000)
	IniWrite($DataFile, "QQ", "AndroidLite", $QQANDLiteNew)
EndIf
If $OLDEditPlusDURL32 <> $EditPlusDURL32 Then
	TrayTip("提示", "检查到 EditPlus32位 最新版，新版开始下载......", 8, 1)
	Beep(600, 1000)
	If FileExists(@ScriptDir & "\New\EditPlus32.EXE") Then FileDelete(@ScriptDir & "\New\EditPlus32.EXE")
	ShellExecute($idmpath, '/n /d ' & $EditPlusDURL32 & ' /p ' & $DownPath & ' /f EditPlus32.EXE', @ScriptDir & "\New", "")
	Sleep(1000)
	IniWrite($DataFile, "EditPlus", "url32", $EditPlusDURL32)
EndIf
If $OLDEditPlusDURL64 <> $EditPlusDURL64 Then
	TrayTip("提示", "检查到 EditPlus64 位最新版，新版开始下载......", 8, 1)
	Beep(600, 1000)
	If FileExists(@ScriptDir & "\New\EditPlus64.EXE") Then FileDelete(@ScriptDir & "\New\EditPlus64.EXE")
	ShellExecute($idmpath, '/n /d ' & $EditPlusDURL64 & ' /p ' & $DownPath & ' /f EditPlus64.EXE', @ScriptDir & "\New", "")
	Sleep(1000)
	IniWrite($DataFile, "EditPlus", "url64", $EditPlusDURL64)
EndIf
If $OLDFlashFxpDURL <> $FlashFxpDURL Then
	TrayTip("提示", "检查到 FlashFxp 最新版，新版开始下载......", 8, 1)
	Beep(600, 1000)
	If FileExists(@ScriptDir & "\New\FlashFxp.EXE") Then FileDelete(@ScriptDir & "\New\FlashFxp.EXE")
	ShellExecute($idmpath, '/n /d ' & $FlashFxpDURL & ' /p ' & $DownPath & ' /f FlashFxp.EXE', @ScriptDir & "\New", "")
	Sleep(1000)
	IniWrite($DataFile, "FlashFxp", "url", $FlashFxpDURL)
EndIf
If $OLDMp3TagDURL <> $Mp3TagDURL Then
	TrayTip("提示", "检查到 Mp3Tag 最新版，新版开始下载......", 8, 1)
	Beep(600, 1000)
	If FileExists(@ScriptDir & "\New\Mp3Tag.EXE") Then FileDelete(@ScriptDir & "\New\Mp3Tag.EXE")
	ShellExecute($idmpath, '/n /d ' & $Mp3TagDURL & ' /p ' & $DownPath & ' /f Mp3Tag.EXE', @ScriptDir & "\New", "")
	Sleep(1000)
	IniWrite($DataFile, "Mp3Tag", "url", $Mp3TagDURL)
EndIf
If $OLDEmEditorDURL32 <> $EmEditorDURL32 Then
	TrayTip("提示", "检查到 EmEditor 32位 最新版，新版开始下载......", 8, 1)
	Beep(600, 1000)
	If FileExists(@ScriptDir & "\New\EmEditor32.EXE") Then FileDelete(@ScriptDir & "\New\EmEditor32.EXE")
	If FileExists(@ScriptDir & "\New\EmEditor32.zip") Then FileDelete(@ScriptDir & "\New\EmEditor32.zip")
	ShellExecute($idmpath, '/n /d ' & $EmEditorDURL32 & ' /p ' & $DownPath & ' /f EmEditor32.zip', @ScriptDir & "\New", "")
	Sleep(1000)
	IniWrite($DataFile, "EmEditor", "url32", $EmEditorDURL32)
EndIf
If $OLDEmEditorDURL64 <> $EmEditorDURL64 Then
	TrayTip("提示", "检查到 EmEditor 64位 最新版，新版开始下载......", 8, 1)
	Beep(600, 1000)
	If FileExists(@ScriptDir & "\New\EmEditor64.EXE") Then FileDelete(@ScriptDir & "\New\EmEditor64.EXE")
	If FileExists(@ScriptDir & "\New\EmEditor64.zip") Then FileDelete(@ScriptDir & "\New\EmEditor64.zip")
	ShellExecute($idmpath, '/n /d ' & $EmEditorDURL64 & ' /p ' & $DownPath & ' /f EmEditor64.zip', @ScriptDir & "\New", "")
	Sleep(1000)
	IniWrite($DataFile, "EmEditor", "url64", $EmEditorDURL64)
EndIf
If $FSCapture <> $OLDFSCapture Then
	TrayTip("提示", "检查到 FastStone Capture 最新版，新版开始下载......", 8, 1)
	Beep(600, 1000)
	If FileExists(@ScriptDir & "\New\FSCapture.zip") Then FileDelete(@ScriptDir & "\New\FSCapture.zip")
	ShellExecute($idmpath, '/n /d ' & $FSCapture & ' /p ' & $DownPath & ' /f FSCapture.zip', @ScriptDir & "\New", "")
	Sleep(1000)
	IniWrite($DataFile, "FSCapture", "url", $FSCapture)
EndIf
If $GIFCAMNEWSIZE <> $GIFCAMOldSIZE Then
	TrayTip("提示", "检查到 GifCam 最新版，版本为：" & $GIFCAMNEWSIZE & "，新版开始下载......", 8, 1)
	Beep(600, 1000)
	If FileExists(@ScriptDir & "\New\GifCam.zip") Then FileDelete(@ScriptDir & "\New\GifCam.zip")
	ShellExecute($idmpath, '/n /d "http://www.bahraniapps.com/apps/gifcam/GifCam.zip" /p ' & $DownPath, @ScriptDir & "\New", "")
	Sleep(1000)
	IniWrite($DataFile, "GIFCAM", "ver", $GIFCAMNEWSIZE)
EndIf
If $HyperSnapNEWSIZE <> $HyperSnapOldSIZE Then
	TrayTip("提示", "检查到 HyperSnap 最新版，开始调用IDM下载......", 8, 1)
	Beep(600, 1000)
	If FileExists(@ScriptDir & "\New\HS8Setup.exe") Then FileDelete(@ScriptDir & "\New\HS8Setup.exe")
	If FileExists(@ScriptDir & "\New\HS8Setup32.exe") Then FileDelete(@ScriptDir & "\New\HS8Setup32.exe")
	ShellExecute($idmpath, '/n /d "http://www.hyperionics.com/downloads/HS8Setup32.exe" /p ' & $DownPath, @ScriptDir & "\New", "")
	Sleep(1000)
	ShellExecute($idmpath, '/n /d "http://www.hyperionics.com/downloads/HS8Setup.exe" /p ' & $DownPath, @ScriptDir & "\New", "")
	Sleep(1000)
	IniWrite($DataFile, "HyperSnap", "ver", $HyperSnapNEWSIZE)
EndIf
If $BeyondCompareDURL <> $OLDBeyondCompareDURL Then
	TrayTip("提示", "检查到 BeyondCompare 最新版，新版开始下载......", 8, 1)
	Beep(600, 1000)
	If FileExists(@ScriptDir & "\New\BeyondCompare-ZH.exe") Then FileDelete(@ScriptDir & "\New\BeyondCompare-ZH.exe")
	ShellExecute($idmpath, '/n /d ' & $BeyondCompareDURL & ' /p ' & $DownPath & ' /f BeyondCompare-ZH.exe', @ScriptDir & "\New", "")
	Sleep(1000)
	IniWrite($DataFile, "BeyondCompare", "url", $BeyondCompareDURL)
EndIf
If $NewPowerISO <> $OLDPowerISO Then
	TrayTip("提示", "检查到 PowerISO 最新版，新版开始下载......", 8, 1)
	Beep(600, 1000)
	If FileExists(@ScriptDir & "\New\PowerISO6.exe") Then FileDelete(@ScriptDir & "\New\PowerISO6.exe")
	If FileExists(@ScriptDir & "\New\PowerISO6-x64.exe") Then FileDelete(@ScriptDir & "\New\PowerISO6-x64.exe")
	ShellExecute($idmpath, '/n /d "http://www.poweriso-files.com/PowerISO6.exe" /p ' & $DownPath, @ScriptDir & "\New", "")
	Sleep(1000)
	ShellExecute($idmpath, '/n /d "http://www.poweriso-files.com/PowerISO6-x64.exe" /p ' & $DownPath, @ScriptDir & "\New", "")
	Sleep(1000)
	IniWrite($DataFile, "PowerISO", "size", $NewPowerISO)
EndIf
If $NewPicPick <> $OLDpicpick Then
	TrayTip("提示", "检查到 picpick 最新版，新版开始下载......", 8, 1)
	Beep(600, 1000)
	If FileExists(@ScriptDir & "\New\picpick_portable.zip") Then FileDelete(@ScriptDir & "\New\picpick_portable.zip")
	ShellExecute($idmpath, '/n /d "http://www.nteworks.com/latestdownload/picpick_portable.zip" /p ' & $DownPath, @ScriptDir & "\New", "")
	Sleep(1000)
	IniWrite($DataFile, "picpick", "size", $NewPicPick)
EndIf
If $NewUltraISO <> $OLDUltraISO Then
	TrayTip("提示", "检查到 UltraISO 最新版，新版开始下载......", 8, 1)
	Beep(600, 1000)
	If FileExists(@ScriptDir & "\New\UltraISO_PE.exe") Then FileDelete(@ScriptDir & "\New\UltraISO_PE.exe")
	ShellExecute($idmpath, '/n /d "http://dw.ezbsys.net/uiso9_pe.exe" /p ' & $DownPath, @ScriptDir & "\New", "")
	Sleep(1000)
	IniWrite($DataFile, "UltraISO", "size", $NewUltraISO)
EndIf
If $NewAliIM <> $OLDAliIM Then
	TrayTip("提示", "检查到 阿里旺旺买家版 最新版，新版开始下载......", 8, 1)
	Beep(600, 1000)
	If FileExists(@ScriptDir & "\New\AliIM.exe") Then FileDelete(@ScriptDir & "\New\AliIM.exe")
	ShellExecute($idmpath, '/n /d "http://download.wangwang.taobao.com/AliIm_taobao.php" /p ' & $DownPath, @ScriptDir & "\New", "")
	Sleep(1000)
	IniWrite($DataFile, "AliIM", "size", $NewAliIM)
EndIf
If $NewcFos <> $OLDcFos Then
	TrayTip("提示", "检查到 cFosSpeed 正式版 最新版，新版开始下载......", 8, 1)
	Beep(600, 1000)
	ShellExecute($idmpath, '/n /d ' & $NewcFos & ' /p ' & $DownPath, @ScriptDir & "\New", "")
	Sleep(1000)
	IniWrite($DataFile, "cFosSpeed", "url1", $NewcFos)
EndIf
If $NewcFosb <> $OLDcFosb Then
	TrayTip("提示", "检查到 cFosSpeed 测试版 最新版，新版开始下载......", 8, 1)
	Beep(600, 1000)
	ShellExecute($idmpath, '/n /d ' & $NewcFosb & ' /p ' & $DownPath, @ScriptDir & "\New", "")
	Sleep(1000)
	IniWrite($DataFile, "cFosSpeed", "url2", $NewcFosb)
EndIf
If $New7star <> $OLD7star Then
	TrayTip("提示", "检查到 七星浏览器 最新版，新版开始下载......", 8, 1)
	Beep(600, 1000)
	ShellExecute($idmpath, '/n /d ' & $New7star & ' /p ' & $DownPath, @ScriptDir & "\New", "")
	Sleep(1000)
	IniWrite($DataFile, "7star", "url", $New7star)
EndIf
If $Newcpuz <> $OLDcpuz Then
	TrayTip("提示", "检查到 CPU-Z 最新版，新版开始下载......", 8, 1)
	Beep(600, 1000)
	ShellExecute($idmpath, '/n /d ' & $Newcpuz & ' /p ' & $DownPath, @ScriptDir & "\New", "")
	Sleep(1000)
	IniWrite($DataFile, "CPU-Z", "url", $Newcpuz)
EndIf
If $TeamViewerNEW <> $OLDTeamViewer Then
	TrayTip("提示", "检查到 TeamViewer 最新版，新版开始下载......", 8, 1)
	Beep(600, 1000)
	If FileExists(@ScriptDir & "\New\TeamViewerPortable.zip") Then FileDelete(@ScriptDir & "\New\TeamViewerPortable.zip")
	ShellExecute($idmpath, '/n /d "http://downloadap3.teamviewer.com/download/TeamViewerPortable.zip" /p ' & $DownPath, @ScriptDir & "\New", "")
	Sleep(1000)
	IniWrite($DataFile, "TeamViewer", "size", $TeamViewerNEW)
EndIf
If $fdminstNEW <> $OLDfdminst Then
	TrayTip("提示", "检查到 FDM 最新版，新版开始下载......", 8, 1)
	Beep(600, 1000)
	If FileExists(@ScriptDir & "\New\fdminst.exe") Then FileDelete(@ScriptDir & "\New\fdminst.exe")
	ShellExecute($idmpath, '/n /d "http://f0.freedownloadmanager.org/fdminst.exe" /p ' & $DownPath, @ScriptDir & "\New", "")
	Sleep(1000)
	IniWrite($DataFile, "fdminst", "size", $fdminstNEW)
EndIf
If $NewAudioShell <> $OLDAudioShell Then
	TrayTip("提示", "检查到 AudioShell 最新版，新版开始下载......", 8, 1)
	Beep(600, 1000)
	ShellExecute($idmpath, '/n /d ' & $NewAudioShell & ' /p ' & $DownPath, @ScriptDir & "\New", "")
	Sleep(1000)
	IniWrite($DataFile, "AudioShell", "url", $NewAudioShell)
EndIf
If $Newdisktool <> $OLDdisktool Then
	TrayTip("提示", "检查到 分区助手 最新版，新版开始下载......", 8, 1)
	Beep(600, 1000)
	If FileExists(@ScriptDir & "\New\PAGreen.zip") Then FileDelete(@ScriptDir & "\New\PAGreen.zip")
	ShellExecute($idmpath, '/n /d "http://www.aomeisoftware.com/download/pacn/PAGreen.zip" /p ' & $DownPath, @ScriptDir & "\New", "")
	Sleep(1000)
	IniWrite($DataFile, "disktool", "size", $Newdisktool)
EndIf
If $NewXnView <> $OLDXnView Then
	TrayTip("提示", "检查到 XnView " & $NewXnView & "，新版开始下载......", 8, 1)
	Beep(600, 1000)
	If FileExists(@ScriptDir & "\New\XnView-win.zip") Then FileDelete(@ScriptDir & "\New\XnView-win.zip")
	ShellExecute($idmpath, '/n /d "http://download.xnview.com/XnView-win.zip" /p ' & $DownPath, @ScriptDir & "\New", "")
	Sleep(1000)
	IniWrite($DataFile, "XnView", "ver", $NewXnView)
EndIf
If $NewWinRAR <> $OLDWinRAR Then
	TrayTip("提示", "检查到 WinRAR英文版 最新版，新版开始下载......", 8, 1)
	Beep(600, 1000)
	ShellExecute($idmpath, '/n /d ' & $NewWinRAR32EngUrl & ' /p ' & $DownPath, @ScriptDir & "\New", "")
	Sleep(1000)
	ShellExecute($idmpath, '/n /d ' & $NewWinRAR64EngUrl & ' /p ' & $DownPath, @ScriptDir & "\New", "")
	Sleep(1000)
	IniWrite($DataFile, "WinRAR", "EngVer", $NewWinRAR)
EndIf
;If $NewWinRARC <> $OLDWinRARC Then
;TrayTip("提示", "检查到 WinRAR中文版 最新版，新版开始下载......", 8, 1)
;Beep(600, 1000)
;ShellExecute($idmpath, '/n /d ' & $NewWinRAR32ChnUrl & ' /p ' & $DownPath, @ScriptDir & "\New", "")
;Sleep(1000)
;Sleep(1000)
;IniWrite($DataFile, "WinRAR", "ChnVer", $NewWinRARC)
;EndIf
If $OLDsandboxie32 <> $Newsandboxie32 Or $OLDsandboxie64 <> $Newsandboxie64 Then
	TrayTip("提示", "检查到 Sandboxie 最新版，新版开始下载......", 8, 1)
	Beep(600, 1000)
	ShellExecute($idmpath, '/n /d ' & $Newsandboxie32 & ' /p ' & $DownPath, @ScriptDir & "\New", "")
	Sleep(1000)
	ShellExecute($idmpath, '/n /d ' & $Newsandboxie64 & ' /p ' & $DownPath, @ScriptDir & "\New", "")
	Sleep(1000)
	IniWrite($DataFile, "sandboxie", "url32", $Newsandboxie32)
	IniWrite($DataFile, "sandboxie", "url64", $Newsandboxie64)
EndIf
If $NewAutoruns <> $OLDAutoruns Then
	TrayTip("提示", "检查到 Autoruns 最新版，新版开始下载......", 8, 1)
	Beep(600, 1000)
	If FileExists(@ScriptDir & "\New\Autoruns.zip") Then FileDelete(@ScriptDir & "\New\Autoruns.zip")
	ShellExecute($idmpath, '/n /d "https://download.sysinternals.com/files/Autoruns.zip" /p ' & $DownPath, @ScriptDir & "\New", "")
	Sleep(1000)
	IniWrite($DataFile, "Autoruns", "date", $NewAutoruns)
EndIf
If $NewSystemExplorer <> $OLDSystemExplorer Then
	TrayTip("提示", "检查到 System Explorer 最新版，新版开始下载.....", 8, 1)
	Beep(600, 1000)
	ShellExecute($idmpath, '/n /d ' & $NewSystemExplorer & ' /p ' & $DownPath, @ScriptDir & "\New", "")
	IniWrite($DataFile, "SystemExplorer", "size", $NewSystemExplorer)
EndIf
;If $NEWFoxitreader <> $OLDFoxitreader Then
;TrayTip("提示", "检查到 Foxit Reader 最新版，由于无法确定具体下载地址，下面打开浏览器请自行下载......", 8, 1)
;Beep(600, 1000)
;Run(@ProgramFilesDir & "\Internet Explorer\iexplore.exe http://cdn01.foxitsoftware.com/pub/foxit/reader/desktop/win")
;IniWrite($DataFile, "Foxitreader", "time", $NEWFoxitreader)
;EndIf
If $New7Zip32b <> $OLD7Zip32b Then
	TrayTip("提示", "检查到 7-Zip测试版 最新版，新版开始下载......", 8, 1)
	Beep(600, 1000)
	ShellExecute($idmpath, '/n /d ' & $New7Zip32b & ' /p ' & $DownPath, @ScriptDir & "\New", "")
	Sleep(1000)
	ShellExecute($idmpath, '/n /d ' & $New7Zip64b & ' /p ' & $DownPath, @ScriptDir & "\New", "")
	Sleep(1000)
	IniWrite($DataFile, "7-Zip", "url32b", $New7Zip32b)
	IniWrite($DataFile, "7-Zip", "url64b", $New7Zip64b)
EndIf
If $New7Zip32s <> $OLD7Zip32s Then
	TrayTip("提示", "检查到 7-Zip正式版 最新版，新版开始下载......", 8, 1)
	Beep(600, 1000)
	ShellExecute($idmpath, '/n /d ' & $New7Zip32s & ' /p ' & $DownPath, @ScriptDir & "\New", "")
	Sleep(1000)
	ShellExecute($idmpath, '/n /d ' & $New7Zip64s & ' /p ' & $DownPath, @ScriptDir & "\New", "")
	Sleep(1000)
	IniWrite($DataFile, "7-Zip", "url32s", $New7Zip32s)
	IniWrite($DataFile, "7-Zip", "url64s", $New7Zip64s)
EndIf
;If $NEWThunderSP <> $OLDThunderSP Then
;TrayTip("提示", "检查到 迅雷极速版 最新版，新版开始下载......", 8, 1)
;Beep(600, 1000)
;ShellExecute($idmpath, '/n /d ' & $NEWThunderSP & ' /p ' & $DownPath, @ScriptDir & "\New", "")
;Sleep(1000)
;IniWrite($DataFile, "ThunderSP", "url", $NEWThunderSP)
;EndIf
If $NEWAIDA64 <> $OLDAIDA64 Then
	TrayTip("提示", "检查到 AIDA64 最新版，新版开始下载......", 8, 1)
	Beep(600, 1000)
	ShellExecuteWait($idmpath, '/n /d ' & $NEWAIDA64 & ' /p ' & $DownPath, @ScriptDir & "\New", "")
	$NEWAIDA64E = StringReplace($NEWAIDA64, "extreme", "engineer", 0, 0)
	$NEWAIDA64B = StringReplace($NEWAIDA64, "extreme", "business", 0, 0)
	ShellExecuteWait($idmpath, '/n /d ' & $NEWAIDA64E & ' /p ' & $DownPath, @ScriptDir & "\New", "")
	Sleep(1000)
	ShellExecuteWait($idmpath, '/n /d ' & $NEWAIDA64B & ' /p ' & $DownPath, @ScriptDir & "\New", "")
	Sleep(1000)
	IniWrite($DataFile, "AIDA64", "url", $NEWAIDA64)
EndIf
If $NEWWinContig <> $OLDWinContig Then
	TrayTip("提示", "检查到 WinContig 最新版，新版开始下载......", 8, 1)
	Beep(600, 1000)
	If FileExists(@ScriptDir & "\NEW\WContig.zip") Then FileDelete(@ScriptDir & "\NEW\WContig.zip")
	ShellExecuteWait($idmpath, '/n /d "http://www.mdtzone.it/Files/WContig.zip" /p ' & $DownPath, @ScriptDir & "\New", "")
	Sleep(1000)
	IniWrite($DataFile, "WinContig", "ver", $NEWWinContig)
EndIf
If $NEWSSDZ <> $OLDSSDZ Then
	TrayTip("提示", "检查到 SSD-Z 最新版，新版开始下载......", 8, 1)
	Beep(600, 1000)
	ShellExecute($idmpath, '/n /d ' & $NEWSSDZ & ' /p ' & $DownPath, @ScriptDir & "\New", "")
	Sleep(1000)
	IniWrite($DataFile, "SSDZ", "url", $NEWSSDZ)
EndIf
If $NEWFSViewer <> $OLDFSViewer Then
	TrayTip("提示", "检查到 FastStone Image Viewer 最新版，新版开始下载......", 8, 1)
	Beep(600, 1000)
	ShellExecute($idmpath, '/n /d ' & $NEWFSViewer & ' /p ' & $DownPath, @ScriptDir & "\New", "")
	Sleep(1000)
	IniWrite($DataFile, "FSViewer", "url", $NEWFSViewer)
EndIf
If $NEWFSResizer <> $OLDFSResizer Then
	TrayTip("提示", "检查到 FastStone Photo Resizer 最新版，新版开始下载......", 8, 1)
	Beep(600, 1000)
	ShellExecute($idmpath, '/n /d ' & $NEWFSResizer & ' /p ' & $DownPath, @ScriptDir & "\New", "")
	Sleep(1000)
	IniWrite($DataFile, "FSResizer", "url", $NEWFSResizer)
EndIf
If $NEWNotepad2 <> $OLDNotepad2 Then
	TrayTip("提示", "检查到 Notepad2-Mod 最新版，新版开始下载......", 8, 1)
	Beep(600, 1000)
	ShellExecute($idmpath, '/n /d ' & $NEWNotepad2 & ' /p ' & $DownPath, @ScriptDir & "\New", "")
	IniWrite($DataFile, "Notepad2", "url", $NEWNotepad2)
EndIf
If $NewFlashPlayer <> $OLDFlashPlayer Then
	TrayTip("提示", "检查到 Adobe Flash Player 最新版，新版开始下载......", 8, 1)
	Beep(600, 1000)
	ShellExecute($idmpath, '/n /d "http://fpdownload.macromedia.com/pub/flashplayer/latest/help/install_flash_player_ax.exe"  /p ' & $DownPath, @ScriptDir & "\New", "")
	Sleep(1000)
	ShellExecute($idmpath, '/n /d "http://fpdownload.macromedia.com/pub/flashplayer/latest/help/install_flash_player.exe" /p ' & $DownPath, @ScriptDir & "\New", "")
	Sleep(1000)
	ShellExecute($idmpath, '/n /d "http://fpdownload.macromedia.com/pub/flashplayer/latest/help/install_flash_player_ppapi.exe" /p ' & $DownPath, @ScriptDir & "\New", "")
	Sleep(1000)
	IniWrite($DataFile, "FlashPlayer", "size", $NewFlashPlayer)
EndIf
If $NewVMWare <> $OLDVMWare Then
	TrayTip("提示", "检查到 VMware Workstation 最新版，新版开始下载......", 8, 1)
	Beep(600, 1000)
	ShellExecute($idmpath, '/n /d "http://www.vmware.com/go/tryworkstation-win"  /p ' & $DownPath, @ScriptDir & "\New", "")
	Sleep(1000)
	IniWrite($DataFile, "VMWare", "size", $NewVMWare)
EndIf
If $NEWEverythingx64 <> $OLDEverythingx64 And $NEWEverythingx86 <> $OLDEverythingx86 Then
	TrayTip("提示", "检查到 Everything 最新版，新版开始下载......", 8, 1)
	Beep(600, 1000)
	ShellExecute($idmpath, '/n /d ' & $NEWEverythingx64 & ' /p ' & $DownPath, @ScriptDir & "\New", "")
	Sleep(1000)
	ShellExecute($idmpath, '/n /d ' & $NEWEverythingx86 & ' /p ' & $DownPath, @ScriptDir & "\New", "")
	Sleep(1000)
	IniWrite($DataFile, "Everything", "url1", $NEWEverythingx86)
	IniWrite($DataFile, "Everything", "url2", $NEWEverythingx64)
EndIf
If $NEWBaidumusic <> $OLDBaidumusic Then
	TrayTip("提示", "检查到 百度音乐 最新版，新版开始下载......", 8, 1)
	Beep(600, 1000)
	ShellExecute($idmpath, '/n /d ' & $NEWBaidumusic & ' /p ' & $DownPath, @ScriptDir & "\New", "")
	Sleep(1000)
	IniWrite($DataFile, "Baidumusic", "url", $NEWBaidumusic)
EndIf
If $NewUltraEdit <> $OLDUltraEdit Then
	TrayTip("提示", "检查到 UltraEdit 最新版，新版开始下载......", 8, 1)
	Beep(600, 1000)
	ShellExecute($idmpath, '/n /d "http://www.ultraedit.com/files/ue_chinese.exe" /p ' & $DownPath, @ScriptDir & "\New", "")
	Sleep(1000)
	IniWrite($DataFile, "UltraEdit", "size", $NewUltraEdit)
EndIf
If $Newhoneyview <> $OLDhoneyview Then
	TrayTip("提示", "检查到 honeyview 最新版，新版开始下载......", 8, 1)
	Beep(600, 1000)
	ShellExecute($idmpath, '/n /d "http://down.bandisoft.com/honeyview/HONEYVIEW-SETUP.EXE" /p ' & $DownPath, @ScriptDir & "\New", "")
	Sleep(1000)
	IniWrite($DataFile, "honeyview", "size", $Newhoneyview)
EndIf
If $Newbandizip <> $OLDbandizip Then
	TrayTip("提示", "检查到 bandizip 最新版，新版开始下载......", 8, 1)
	Beep(600, 1000)
	ShellExecute($idmpath, '/n /d "http://down.bandisoft.com/bandizip/BANDIZIP-SETUP.EXE" /p ' & $DownPath, @ScriptDir & "\New", "")
	Sleep(1000)
	IniWrite($DataFile, "bandizip", "size", $Newbandizip)
EndIf

If $Newbandicam <> $OLDbandicam Then
	TrayTip("提示", "检查到 bandicam 最新版，新版开始下载......", 8, 1)
	Beep(600, 1000)
	ShellExecute($idmpath, '/n /d "http://ca-dl.bandicam.com/bdcamsetup.exe" /p ' & $DownPath, @ScriptDir & "\New", "")
	Sleep(1000)
	IniWrite($DataFile, "bandicam", "size", $Newbandicam)
EndIf

If $NewStartIsBack <> $OLDStartIsBack Then
	TrayTip("提示", "检查到 StartIsBack++ 最新版，新版开始下载......", 8, 1)
	Beep(600, 1000)
	ShellExecute($idmpath, '/n /d "https://s3.amazonaws.com/startisback/StartIsBackPlusPlus_setup.exe" /p ' & $DownPath, @ScriptDir & "\New", "")
	Sleep(1000)
	IniWrite($DataFile, "StartIsBack", "size", $NewStartIsBack)
EndIf

If $NewDictionary <> $OLDDictionary Then
	TrayTip("提示", "检查到 Dictionary.Net 最新版，新版开始下载......", 8, 1)
	Beep(600, 1000)
	ShellExecute($idmpath, '/n /d "http://fishcodelib.com/files/DictionaryNet.zip" /p ' & $DownPath, @ScriptDir & "\New", "")
	Sleep(1000)
	IniWrite($DataFile, "Dictionary", "size", $NewDictionary)
EndIf

If $NEWClassicShell <> $OLDClassicShell Then
	TrayTip("提示", "检查到 Classic Shell 最新版，由于官网有防止盗链功能，下面打开浏览器进行下载......", 8, 1)
	Beep(600, 1000)
	Run(@ProgramFilesDir & "\Internet Explorer\iexplore.exe" & " " & $NEWClassicShell)
	Sleep(1000)
	IniWrite($DataFile, "ClassicShell", "url", $NEWClassicShell)
EndIf

If $NEWvirtualbox <> $OLDvirtualbox Then
	TrayTip("提示", "检查到 virtualbox  最新版，新版开始下载......", 8, 1)
	Beep(600, 1000)
	ShellExecute($idmpath, '/n /d ' & $NEWvirtualbox & ' /p ' & $DownPath, @ScriptDir & "\New", "")
	Sleep(1000)
	IniWrite($DataFile, "virtualbox", "url", $NEWvirtualbox)
EndIf

TrayTip("提示", "对比完成！程序退出！", 2, 1)
Sleep(1000)
FileSetAttrib($DataFile, "+R")
Sleep(1000)
Exit


