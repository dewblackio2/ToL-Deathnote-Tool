#cs

  _______    _        _____             _   _                 _         _______          _
 |__   __|  | |      |  __ \           | | | |               | |       |__   __|        | |
    | | ___ | |      | |  | | ___  __ _| |_| |__  _ __   ___ | |_ ___     | | ___   ___ | |
    | |/ _ \| |      | |  | |/ _ \/ _` | __| '_ \| '_ \ / _ \| __/ _ \    | |/ _ \ / _ \| |
    | | (_) | |____  | |__| |  __/ (_| | |_| | | | | | | (_) | ||  __/    | | (_) | (_) | |
    |_|\___/|______| |_____/ \___|\__,_|\__|_| |_|_| |_|\___/ \__\___|    |_|\___/ \___/|_|
    ___        ___             _    _         _   _     ___   __       ___ _        _ _
   | _ )_  _  |   \ _____ __ _| |__| |__ _ __| |_(_)___|_  ) / _|___  / __| |_  _ _(_) |_____
   | _ \ || | | |) / -_) V  V / '_ \ / _` / _| / / / _ \/ /  > _|_ _| \__ \ ' \| '_| | / / -_)
   |___/\_, | |___/\___|\_/\_/|_.__/_\__,_\__|_\_\_\___/___| \_____|  |___/_||_|_| |_|_\_\___|
	    |__/

Throne Of Lies Deathnote Tool
Created By: Dewblackio2 (Nolan Karjala)
IMMENSE Help, Additions, and Optimizations By: Shrike (Matt Thomas), ShrikeGames.com

#ce

;Constants and API Files
#include <GUIConstants.au3>
#include <EditConstants.au3>
#include <WindowsConstants.au3>
#include <StaticConstants.au3>
#include <Color.au3>
#include <WinAPI.au3>
#include <APIConstants.au3>
#include <misc.au3>
#include <MsgBoxConstants.au3>
#include <GDIPlus.au3>

;Initialize Global Variables
Global $hWin
Global $aPos
Global $imageBox
Global $imageWD
Global $imageHD
Global $origWidth
Global $origHeight
Global $GUI
Global $bPos
Global $dc
Global $memDc
Global $bitmap
Global $bits
Global $drawFrame = False
Global $drawing = 0
Global $thresholds[11] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $width
Global $height
Global $pixels
Global $codes
Global $pathString = "12345678"
Global $scramble = False
Global $rotate = 0
Global $speed = 0
Global $speedMouse
Global $scriptPause = False
Global $zoomHold = False
Global $mouseloca = MouseGetPos()
Global $useColor[12] = [True, False, False, False, False, False, False, False, False, False, False, False]
Global $foundColors[12] = [False, False, False, False, False, False, False, False, False, False, False, False]
Global $selections[11] = ["Please Select BLACK for draw color then press F6 to continue!", "Please Select YELLOW for draw color then press F6 to continue!", "Please Select BLUE for draw color then press F6 to continue!", "Please Select PINK for draw color then press F6 to continue!", "Please Select WHITE for draw color then press F6 to continue!", "Please Select RED for draw color then press F6 to continue!", "Please Select GREEN for draw color then press F6 to continue!", "Please Select PURPLE for draw color then press F6 to continue!", "Please Select GREY for draw color then press F6 to continue!", "Please Select ORANGE for draw color then press F6 to continue!", "Please Select TEAL for draw color then press F6 to continue!"] ;yellow - blue - pink - white - Red - green - purple
Global $pixelHolder = False
Global $skipColor = False
Global $mouselocaPrevious = MouseGetPos()
Global $mousePressed = False
Global $selectingBackgroundColor = False
Global $rgb2LabMap = ObjCreate("Scripting.Dictionary")

Global $ToLColors[11] = [0x000000, 0xc8b800, 0x007cc3, 0xe173df, 0xe1e1e1, 0x960000, 0x009600, 0x790098, 0x808080, 0xFD8C00, 0x01CCD0] ;Black - yellow - blue - pink - white - Red - green - purple - grey - orange - teal
Global $rHolds[11]=[0,0,0,0,0,0,0,0,0,0,0]
Global $gHolds[11]=[0,0,0,0,0,0,0,0,0,0,0]
Global $bHolds[11]=[0,0,0,0,0,0,0,0,0,0,0]
Global $lab2s[11]=[0,0,0,0,0,0,0,0,0,0,0]
For $i = 0 To 10
	$rHolds[$i] = _ColorGetRed($ToLColors[$i])
	$gHolds[$i] = _ColorGetGreen($ToLColors[$i])
	$bHolds[$i] = _ColorGetBlue($ToLColors[$i])
	$lab2s[$i] = rgb2lab ($rHolds[$i], $gHolds[$i], $bHolds[$i])
Next

;START GUIMsgBox - Shows a message box in the GUI
Func GUIMsgBox($type, $title, $text)

	MsgBox($type, $title, $text)
EndFunc
;END GUIMsgBox

;TODO remove when added to GUI
GUIMsgBox($MB_ICONWARNING, "Warning", "Using this software to draw any form of obscenities or NSFW content on your deathnote, will result in a flag against your Throne of Lies account and may result in a permanent suspension. By using this application, you agree to these terms.")

Global $currentVersion = "1.3"
Global $configFile = (@ScriptDir & "\ToLDNConfig.ini")

InetGet("http://raw.githubusercontent.com/dewblackio2/ToL-Deathnote-Tool/master/Version.txt", @ScriptDir & "\Version.txt")
$versionCheck = FileReadLine(@ScriptDir & "\Version.txt")
If $versionCheck <> $currentVersion Then
	If GUIMsgBox(262209, "ToL Deathnote Tool", "Update Available!" & @CRLF & "Current Version: " & $currentVersion & " | Update Version: " & $versionCheck & @CRLF & @CRLF & "Press 'OK' to Download") = 1 Then
		FileDelete(@ScriptDir & "\Version.txt")
		ShellExecute("http://github.com/dewblackio2/ToL-Deathnote-Tool/archive/master.zip")
		GUIMsgBox($MB_ICONINFORMATION, "ToL Deathnote Tool", "New version downloaded." & @CRLF & "Please check your browsers download destination folder for the archive file." & @CRLF & @CRLF & "Script will now exit.", 20)
		Exit
	EndIf
EndIf
FileDelete(@ScriptDir & "\Version.txt")

;TODO remove this
;prevent program from running if main hotkeys are bound to something
If (Not HotKeySet("{F9}", "Nothing")) Then
	GUIMsgBox(16, "Error", "Could not register the F9 hotkey.")
	Exit
EndIf
If (Not HotKeySet("{F10}", "Nothing")) Then
	GUIMsgBox(16, "Error", "Could not register the F10 hotkey.")
	Exit
EndIf
If (Not HotKeySet("{F8}", "Nothing")) Then
	GUIMsgBox(16, "Error", "Could not register the F8 hotkey.")
	Exit
EndIf
If (Not HotKeySet("{F7}", "Nothing")) Then
	GUIMsgBox(16, "Error", "Could not register the F7 hotkey.")
	Exit
EndIf
If (Not HotKeySet("{F6}", "Nothing")) Then
	GUIMsgBox(16, "Error", "Could not register the F6 hotkey.")
	Exit
EndIf


$disableWindowBarOptions = -1
;read the values from the config file if they are there
$windowPosX = GetConfigValue("Window","windowPosX",-1)
$windowPosY = GetConfigValue("Window","windowPosY",-1)
$windowStyle = GetConfigValue("Window","windowStyle",-1)
$windowTitle = "ToL Deathnote Tool v" & $currentVersion
$bgTolerance = GetConfigValue("Settings","bgTolerance",0)
$debug = GetConfigValue("Settings","debug",False)
Func GetConfigValue($category, $propertyKey, $defaultValue)
	If FileExists($configFile) Then
		$value = IniRead($configFile, $category, $propertyKey, $defaultValue)
		return $value
	EndIf
EndFunc

Func UpdateConfig()
	$windowPos = WinGetPos($windowTitle)
	IniWrite($configFile, "Window", "windowPosX", $windowPos[0] - $guiWidth)
	IniWrite($configFile, "Window", "windowPosY", $windowPos[1])

	If (GUICtrlRead($horizontalRadio) == $GUI_CHECKED) Then
		IniWrite($configFile, "Settings", "Pattern", "horizontal")
	ElseIf (GUICtrlRead($verticalRadio) == $GUI_CHECKED) Then
		IniWrite($configFile, "Settings", "Pattern", "vertical")
	ElseIf (GUICtrlRead($diagonalRadio) == $GUI_CHECKED) Then
		IniWrite($configFile, "Settings", "Pattern", "diagonal")
	ElseIf (GUICtrlRead($rotateRadio) == $GUI_CHECKED) Then
		IniWrite($configFile, "Settings", "Pattern", "spiral")
	ElseIf (GUICtrlRead($scrambleRadio) == $GUI_CHECKED) Then
		IniWrite($configFile, "Settings", "Pattern", "random")
	EndIf
	IniWrite($configFile, "Settings", "Speed", GUICtrlRead($speedInput))
	IniWrite($configFile, "Settings", "blackThresh", GUICtrlRead($blackThresh))
	IniWrite($configFile, "Settings", "yellowThresh", GUICtrlRead($yellowThresh))
	IniWrite($configFile, "Settings", "blueThresh", GUICtrlRead($blueThresh))
	IniWrite($configFile, "Settings", "pinkThresh", GUICtrlRead($pinkThresh))
	IniWrite($configFile, "Settings", "whiteThresh", GUICtrlRead($whiteThresh))
	IniWrite($configFile, "Settings", "redThresh", GUICtrlRead($redThresh))
	IniWrite($configFile, "Settings", "greenThresh", GUICtrlRead($greenThresh))
	IniWrite($configFile, "Settings", "purpleThresh", GUICtrlRead($purpleThresh))
	IniWrite($configFile, "Settings", "greyThresh", GUICtrlRead($greyThresh))
	IniWrite($configFile, "Settings", "orangeThresh", GUICtrlRead($orangeThresh))
	IniWrite($configFile, "Settings", "tealThresh", GUICtrlRead($tealThresh))
	IniWrite($configFile, "Settings", "bgTolerance", GUICtrlRead($selectedTolerance))
EndFunc   ;==>UpdateConfig


;[] Main Settings Window

;default windowsStyle includes a combination of $WS_MINIMIZEBOX, $WS_CAPTION, $WS_POPUP, $WS_SYSMENU styles.
Global $guiWidth = 800
Global $guiHeight = 850

;START GUI GENERATION
Global $padding = 8
Global $flexX = $padding * 3
Global $flexY = $padding * 3
Global $fieldHeight = 20;

$optGUI = GUICreate($windowTitle, $guiWidth*2, $guiHeight, $windowPosX+$guiWidth, $windowPosY, $disableWindowBarOptions, $windowStyle)

;BANNER SETTINGS
$bannerSettingsLeft = $padding * 2
$bannerSettingsTop = $padding * 2
$bannerSettingsWidth =  ($guiWidth) - ($padding *3)
$bannerSettingsHeight = 150 + ( $padding *2 )
GUICtrlCreateGroup("Throne of Lies Deathnote Tool", $bannerSettingsLeft, $bannerSettingsTop, $bannerSettingsWidth, $bannerSettingsHeight, BitOR($GUI_SS_DEFAULT_GROUP, $BS_CENTER))
$flexY += $padding
AddGUILabelField("Created By: Dewblackio2")
AddGUILabelField("Support By: Matt Thomas @ShrikeGames")

$donateBtn = AddGUIButton("♥♥ Donate To Dewblackio2 ♥♥")
$flexX = $bannerSettingsLeft + ($bannerSettingsWidth /2) + ($padding *2)
$donateBtn2 = AddGUIButton("♥♥ Donate To ShrikeGames ♥♥")
$flexX = ($padding *3)
$flexY += $fieldHeight+$padding
$openBtn = AddGUIButton("Open") ;open image, all buttons disabled until image loaded
$flexX = $bannerSettingsLeft + ($bannerSettingsWidth /2) + ($padding *2)
$okBtn = AddGUIButton("Apply") ;Apply
$flexX = ($padding *3)
$flexY += $fieldHeight+$padding
$resetBtn = AddGUIButton("Reset") ;Reset
$flexX = $bannerSettingsLeft + ($bannerSettingsWidth /2) + ($padding *2)
$exitBtn = AddGUIButton("Exit") ;Exit
$flexX = ($padding *3)
$flexY += $fieldHeight+$padding
;BANNER SETTINGS


;IMAGE SETTINGS

$imageSettingsLeft = $padding * 2
$imageSettingsTop = $bannerSettingsTop  + $bannerSettingsHeight + $padding * 2
$imageSettingsWidth =  ($guiWidth/2) - ($padding *2)
$imageSettingsHeight = 130
$flexY = $imageSettingsTop
GUICtrlCreateGroup("Image Settings", $imageSettingsLeft, $imageSettingsTop, $imageSettingsWidth, $imageSettingsHeight, BitOR($GUI_SS_DEFAULT_GROUP, $BS_CENTER))
$flexY += $padding * 2
$widthInput = AddGUINumberField("Width (px):","0",True)
$heightInput = AddGUINumberField("Height (px):","0",True)
$showRect = AddGUICheckboxField("Draw Image Size? ", True)
$showRectLabel = AddGUILabelField("(Enables After Pressing Apply)")

;ENDIMAGE SETTINGS

;DRAWING SETTINGS
$drawingSettingsLeft = $padding * 2
$drawingSettingsTop = $imageSettingsTop  + $imageSettingsHeight + $padding * 2
$drawingSettingsWidth =  ($guiWidth/2) - ($padding *2)
$drawingSettingsHeight = 210

$flexY = $drawingSettingsTop
GUICtrlCreateGroup("Drawing Settings", $drawingSettingsLeft, $drawingSettingsTop, $drawingSettingsWidth, $drawingSettingsHeight, BitOR($GUI_SS_DEFAULT_GROUP, $BS_CENTER))
$flexY += $padding * 2
$patternLabel = AddGUILabelField("Pattern:")

$horizontalRadio = AddGUIRadioField(" Horizontal")
$verticalRadio = AddGUIRadioField(" Vertical")
$diagonalRadio = AddGUIRadioField(" Diagonal")
$rotateRadio = AddGUIRadioField(" Spiral")
$scrambleRadio = AddGUIRadioField(" Random")
GUICtrlSetState($diagonalRadio, $GUI_CHECKED)
$speedInput = AddGUINumberField("Mouse speed (0=slow, 100=fast):","5",False)
$flexX = ($padding * 3)
; END DRAWING SETTINGS

;KEYBINDS
$keybindsLeft = $padding * 2
$keybindsTop = $drawingSettingsTop  + $drawingSettingsHeight + $padding * 2
$keybindsWidth =  ($guiWidth/2) - ($padding *2)
$keybindsHeight = 150

$flexY = $keybindsTop
GUICtrlCreateGroup("Keybinds", $keybindsLeft, $keybindsTop, $keybindsWidth, $keybindsHeight, BitOR($GUI_SS_DEFAULT_GROUP, $BS_CENTER))
$flexY += $padding * 2
AddGUILabelField("F9 = Start! and Lock Pos")
AddGUILabelField("F6 = Draw Current Color")
AddGUILabelField("F7 = Skip Current Color")
AddGUILabelField("F8 = Pause / Resume Draw")
AddGUILabelField("F10 = Exit Program")
$backgroundR = GetConfigValue("Settings","backgroundR",255)
$backgroundG = GetConfigValue("Settings","backgroundG",255)
$backgroundB = GetConfigValue("Settings","backgroundB",255)
$selectBackgroundColor = AddGUIButton("Select Background Color") ;Exit
$flexY += $fieldHeight + ($padding)
$selectedBackgroundColor = AddGUINumberField("Background Color:",$backgroundR&","&$backgroundG&","&$backgroundB,True)
$selectedTolerance = AddGUINumberField("Background Tolerance:",$bgTolerance,False)

;END KEYBINDS

;COLOR SETTINGS
$flexX = ($guiWidth/2) + ($padding)
$colorSettingsLeft = $flexX
$colorSettingsTop = $bannerSettingsTop  + $bannerSettingsHeight + $padding * 2
$colorSettingsWidth = ($guiWidth / 2 ) - ($padding *2)
$colorSettingsHeight = $guiHeight - $bannerSettingsHeight -  ($padding *5)

$flexY = $colorSettingsTop
GUICtrlCreateGroup("Color Settings", $colorSettingsLeft, $colorSettingsTop, $colorSettingsWidth, $colorSettingsHeight, BitOR($GUI_SS_DEFAULT_GROUP, $BS_CENTER))
$flexY += $padding * 2
$flexX += $padding

$blackThresh = AddGUINumberField("Black Threshold (0-255):","230",False)
$colorWarningLabel = AddGUILabelField("Using Colors Takes Longer!")

$yellowDet = AddGUIColorCheckboxField("Enable Yellow", False, 0xc8b800)
$yellowThresh = AddGUINumberField("Yellow Threshold (0-255):","150",False)

$blueDet = AddGUIColorCheckboxField("Enable Blue", False, 0x007cc3)
$blueThresh = AddGUINumberField("Blue Threshold (0-255):","150",False)

$pinkDet = AddGUIColorCheckboxField("Enable Pink", False, 0xe173df)
$pinkThresh = AddGUINumberField("Pink Threshold (0-255):","150",False)

$whiteDet = AddGUIColorCheckboxField("Enable White", False, 0xe1e1e1)
$whiteThresh = AddGUINumberField("White Threshold (0-255):","255",False)

$redDet = AddGUIColorCheckboxField("Enable Red", False, 0x960000)
$redThresh = AddGUINumberField("Red Threshold (0-255):","150",False)

$greenDet = AddGUIColorCheckboxField("Enable Green", False, 0x009600)
$greenThresh = AddGUINumberField("Green Threshold (0-255):","150",False)

$purpleDet = AddGUIColorCheckboxField("Enable Purple", False, 0x790098)
$purpleThresh = AddGUINumberField("Purple Threshold (0-255):","150",False)

$greyDet = AddGUIColorCheckboxField("Enable Grey", False, 0x808080)
$greyThresh = AddGUINumberField("Grey Threshold (0-255):","150",False)

$orangeDet = AddGUIColorCheckboxField("Enable Orange", False, 0xFD8C00)
$orangeThresh = AddGUINumberField("Orange Threshold (0-255):","150",False)

$tealDet = AddGUIColorCheckboxField("Enable Teal", False, 0x01CCD0)
$tealThresh = AddGUINumberField("Teal Threshold (0-255):","150",False)
;END COLOR SETTINGS

;IMAGE DISPLAY
$imageDisplayFilename = ""
$imageDisplayLeft = $guiWidth
$imageDisplayTop = 0
$imageDisplayWidth = $guiWidth
$imageDisplayHeight = $guiHeight

$imageDisplay = GUICtrlCreatePic($imageDisplayFilename, $imageDisplayLeft, $imageDisplayTop, $imageDisplayWidth, $imageDisplayHeight, $WS_BORDER + $SS_CENTERIMAGE)
$flexX=$imageDisplayLeft + $padding
$flexY=$imageDisplayTop+($imageDisplayHeight) - $fieldHeight - $padding
AddGUILabelField("Image preview")
;END IMAGE DISPLAY

;UPDATE GUI FROM CONFIG STATE
GUISetState()

If FileExists($configFile) Then
	$patternSelect = IniRead($configFile, "Settings", "Pattern", "diagonal")
	If $patternSelect == "horizontal" Then
		GUICtrlSetState($horizontalRadio, $GUI_CHECKED)
	ElseIf $patternSelect == "vertical" Then
		GUICtrlSetState($verticalRadio, $GUI_CHECKED)
	ElseIf $patternSelect == "diagonal" Then
		GUICtrlSetState($diagonalRadio, $GUI_CHECKED)
	ElseIf $patternSelect == "spiral" Then
		GUICtrlSetState($rotateRadio, $GUI_CHECKED)
	ElseIf $patternSelect == "random" Then
		GUICtrlSetState($scrambleRadio, $GUI_CHECKED)
	EndIf
	$speedSelect = IniRead($configFile, "Settings", "Speed", "5")
	GUICtrlSetData($speedInput, $speedSelect)
	$blackSelect = IniRead($configFile, "Settings", "blackThresh", "230")
	$yellowSelect = IniRead($configFile, "Settings", "yellowThresh", "150")
	$blueSelect = IniRead($configFile, "Settings", "blueThresh", "150")
	$pinkSelect = IniRead($configFile, "Settings", "pinkThresh", "150")
	$whiteSelect = IniRead($configFile, "Settings", "whiteThresh", "255")
	$redSelect = IniRead($configFile, "Settings", "redThresh", "150")
	$greenSelect = IniRead($configFile, "Settings", "greenThresh", "150")
	$purpleSelect = IniRead($configFile, "Settings", "purpleThresh", "150")
	$greySelect = IniRead($configFile, "Settings", "greyThresh", "150")
	$orangeSelect = IniRead($configFile, "Settings", "orangeThresh", "150")
	$tealSelect = IniRead($configFile, "Settings", "tealThresh", "150")
	$bgTolerance = IniRead($configFile, "Settings", "bgTolerance", "0")

	GUICtrlSetData($blackThresh, $blackSelect)
	GUICtrlSetData($yellowThresh, $yellowSelect)
	GUICtrlSetData($blueThresh, $blueSelect)
	GUICtrlSetData($pinkThresh, $pinkSelect)
	GUICtrlSetData($whiteThresh, $whiteSelect)
	GUICtrlSetData($redThresh, $redSelect)
	GUICtrlSetData($greenThresh, $greenSelect)
	GUICtrlSetData($purpleThresh, $purpleSelect)
	GUICtrlSetData($greyThresh, $greySelect)
	GUICtrlSetData($orangeThresh, $orangeSelect)
	GUICtrlSetData($tealThresh, $tealSelect)
 EndIf
Func _MAG($MyhWnd, $l, $t) ;Zoom Bitmap Logic to adjust the GUI to contain 9 pixels, center being color selection for background color modification
    Local $Width = 100, $Height = 100, $ZoomFactor = 32
    Local $MyHDC = DllCall("user32.dll", "int", "GetDC", "hwnd", $MyhWnd); $MyHDC = _WinAPI_GetDC ($MyhWnd)
    If @error Then Return
    Local $DeskHDC = DllCall("user32.dll", "int", "GetDC", "hwnd", 0)   ; $DeskHDC = _WinAPI_GetDC (0)
    If Not @error Then
        DllCall("gdi32.dll", "int", "StretchBlt", "int", $MyHDC[0], "int", 0, "int", 0, "int", $Width, "int", $Height, "int", _
                $DeskHDC[0], "int", $l, "int", $t, "int", $Width / $ZoomFactor, "int", $Height / $ZoomFactor, "long", $SRCCOPY)

        DllCall("user32.dll", "int", "ReleaseDC", "int", $DeskHDC[0], "hwnd", 0); _WinAPI_ReleaseDC ($DeskHDC, 0)
    EndIf
    DllCall("user32.dll", "int", "ReleaseDC", "int", $MyHDC[0], "hwnd", $MyhWnd); _WinAPI_ReleaseDC ($MyhWnd, $MyHDC)
EndFunc  ;==>MAG
;Main Gui Control Messages
While 1
	If $selectingBackgroundColor == True Then ;And _IsPressed("01") Then
	    Local $zoomW = 100, $zoomH = 100, $ZoomFactor = 32
		If $zoomHold == False And Not WinExists("Zoomed") Then
		   $zoomHold = True
		   $zoomGui = GUICreate("Zoomed",$zoomW,$zoomH,MouseGetPos(0),MouseGetPos(1),$WS_POPUP+$WS_BORDER,$WS_EX_TOPMOST)
		   GUISetState()
	    EndIf
		If $zoomHold == True Then
		   Local $aMousePos = MouseGetPos()
		   _MAG($zoomGui, $aMousePos[0] - (($zoomW / $ZoomFactor) / 2) + 1, $aMousePos[1] - (($zoomH / $ZoomFactor) / 2) + 1)
		   WinMove("Zoomed","",$aMousePos[0]+15,$aMousePos[1])
           Sleep(10)
	    EndIf
		$testpos = MouseGetPos()
		$color = PixelGetColor($testpos[0],$testpos[1])
		$backgroundR = _ColorGetRed($color)
		$backgroundG = _ColorGetGreen($color)
		$backgroundB = _ColorGetBlue($color)
		GUICtrlSetData($selectedBackgroundColor, $backgroundR&","&$backgroundG&","&$backgroundB)
		If _IsPressed("01") Then
		  If WinExists("Zoomed") Then
			 GUIDelete($zoomGui)
		  EndIf
		  $zoomHold = False
		  $selectingBackgroundColor = False
		  ;TrayTip("Background Color RGB:", $backgroundR&", "&$backgroundG&", "&$backgroundB, 10)
	    EndIf
	EndIf
	If $drawFrame == True Then
		Sleep(10)
		$aMouse = MouseGetPos()
		WinMove($hWin, "", $aMouse[0] - $aPos[2] / 2, $aMouse[1] - $aPos[3] / 2)
	EndIf
	Switch (GUIGetMsg())
		Case $widthInput
			GUICtrlSetData($heightInput, Int(($origHeight / $origWidth) * GUICtrlRead($widthInput)))
		Case $heightInput
			GUICtrlSetData($widthInput, Int(($origWidth / $origHeight) * GUICtrlRead($heightInput)))
		Case $GUI_EVENT_CLOSE, $exitBtn
			UpdateConfig()
			Exit
		Case $donateBtn
			ShellExecute("http://www.paypal.me/Dewblackio2")
	    Case $donateBtn2
			ShellExecute("http://www.paypal.me/shrikegames")
		Case $selectBackgroundColor
			$selectingBackgroundColor = True
		Case $openBtn
			;$bPos = WinGetPos($optGUI)
			;WinMove($optGUI, "", $bPos[0], $bPos[1], $guiWidth *2, $guiHeight)
			Local $GDIImage
			$imageFile = FileOpenDialog("Open Image", @WorkingDir, "Images (*.jpg;*.jpeg;*.gif;*.bmp)", 1) ;png is not supported in auto it function :c
			If (@error) Then Exit
			_GDIPlus_Startup()
			$GDIImage = _GDIPlus_ImageLoadFromFile($imageFile)
			$imageWD = _GDIPlus_ImageGetWidth($GDIImage)
			$imageHD = _GDIPlus_ImageGetHeight($GDIImage)
			_GDIPlus_ImageDispose($GDIImage)
			_GDIPlus_Shutdown()
			GUICtrlSetState($widthInput, $GUI_ENABLE)
			GUICtrlSetState($heightInput, $GUI_ENABLE)
			$origWidth = $imageWD
			$origHeight = $imageHD
			GUICtrlSetData($widthInput, $imageWD)
			GUICtrlSetData($heightInput, $imageHD)
			Local $factorVar = 1
			If $imageWD > 1065 Or $imageHD > 599 Then
				$imageWD = $imageWD * (599 / $imageHD)
				$factorVar = 599 / $imageHD
				$imageHD = 599
				If $imageWD > 1065 Then
					$imageHD = $imageHD * (1065 / $imageWD)
					$factorVar = 1065 / $imageWD
					$imageWD = 1065
				EndIf
			EndIf
			$imageWD = Int($imageWD)
			$imageHD = Int($imageHD)
			GUICtrlSetPos($imageDisplay, $imageDisplayLeft, $imageDisplayTop, $imageWD, $imageHD)
			GUICtrlSetImage($imageDisplay, $imageFile)
			GUICtrlSetState($openBtn, $GUI_DISABLE)
			GUICtrlSetState($okBtn, $GUI_ENABLE)
			GUICtrlSetState($resetBtn, $GUI_ENABLE)
		Case $showRect
			If (GUICtrlRead($showRect) == $GUI_CHECKED) And $drawing == 0 And $drawFrame == False Then
				$hWin = _GUI_Transparent_Client(GUICtrlRead($widthInput), GUICtrlRead($heightInput), -1, -1, 5, 0xFF0000)
				$aPos = WinGetPos($hWin)
				$drawFrame = True
				;GUISetState(@SW_SHOW, $hWin)
			ElseIf ((GUICtrlRead($showRect) <> $GUI_CHECKED) Or $drawing == 1) And $drawFrame == True Then
				$drawFrame = False
				GUIDelete($hWin)
				;GUISetState(@SW_HIDE, $hWin)
				If (GUICtrlRead($showRect) == $GUI_CHECKED) Then
					GUICtrlSetState($showRect, $GUI_UNCHECKED)
				EndIf
			EndIf
		Case $resetBtn
			UpdateConfig()
			HotKeySet("{F9}")
			HotKeySet("{F10}")
			HotKeySet("{F8}")
			HotKeySet("{F7}")
			HotKeySet("{F6}")
			If @Compiled Then
				ShellExecute(@ScriptFullPath)
			Else
				ShellExecute(@AutoItExe, @ScriptFullPath)
			EndIf
			Exit
		Case $okBtn
			;TrayTip("Color RGB:", $backgroundR&", "&$backgroundG&", "&$backgroundB, 20)
			UpdateConfig()
			If GUICtrlRead($widthInput) > @DesktopWidth Or GUICtrlRead($heightInput) > @DesktopHeight Then
				GUIMsgBox($MB_ICONWARNING, "Error", "Image Size Exceeds Desktop Display Size!")
			Else
				HotKeySet("{F9}")
				HotKeySet("{F10}")
				HotKeySet("{F8}")
				HotKeySet("{F7}")
				HotKeySet("{F6}")
				$pixelHolder = False
				$skipColor = False
				$scriptPause = False
				$drawing = 0
				$bPos = WinGetPos($optGUI)
				;GUICtrlDelete($imageDisplay)
				;GUICtrlDelete($donateBtn)

				;WinMove($optGUI, "", $bPos[0], $bPos[1], $guiWidth, $guiHeight)
				For $j = 1 To 11
					$useColor[$j] = False
				Next
				For $n = 0 To 11
					$foundColors[$n] = False
				Next
				$thresholds[0] = GUICtrlRead($blackThresh)
				$thresholds[1] = GUICtrlRead($yellowThresh)
				$thresholds[2] = GUICtrlRead($blueThresh)
				$thresholds[3] = GUICtrlRead($pinkThresh)
				$thresholds[4] = GUICtrlRead($whiteThresh)
				$thresholds[5] = GUICtrlRead($redThresh)
				$thresholds[6] = GUICtrlRead($greenThresh)
				$thresholds[7] = GUICtrlRead($purpleThresh)
				$thresholds[8] = GUICtrlRead($greyThresh)
				$thresholds[9] = GUICtrlRead($orangeThresh)
				$thresholds[10] = GUICtrlRead($tealThresh)
				$width = GUICtrlRead($widthInput)
				$height = GUICtrlRead($heightInput)
				$speedMouse = GUICtrlRead($speedInput)
				If (GUICtrlRead($yellowDet) == $GUI_CHECKED) Then
					$useColor[1] = True
				EndIf
				If (GUICtrlRead($blueDet) == $GUI_CHECKED) Then
					$useColor[2] = True
				EndIf
				If (GUICtrlRead($pinkDet) == $GUI_CHECKED) Then
					$useColor[3] = True
				EndIf
				If (GUICtrlRead($whiteDet) == $GUI_CHECKED) Then
					$useColor[4] = True
				EndIf
				If (GUICtrlRead($redDet) == $GUI_CHECKED) Then
					$useColor[5] = True
				EndIf
				If (GUICtrlRead($greenDet) == $GUI_CHECKED) Then
					$useColor[6] = True
				EndIf
				If (GUICtrlRead($purpleDet) == $GUI_CHECKED) Then
					$useColor[7] = True
			    EndIf
			    If (GUICtrlRead($greyDet) == $GUI_CHECKED) Then
					$useColor[8] = True
			    EndIf
				If (GUICtrlRead($orangeDet) == $GUI_CHECKED) Then
					$useColor[9] = True
			    EndIf
			    If (GUICtrlRead($tealDet) == $GUI_CHECKED) Then
					$useColor[10] = True
				EndIf
				If (GUICtrlRead($horizontalRadio) == $GUI_CHECKED) Then
					$pathString = "45273618"
				ElseIf (GUICtrlRead($verticalRadio) == $GUI_CHECKED) Then
					$pathString = "27453618"
				ElseIf (GUICtrlRead($diagonalRadio) == $GUI_CHECKED) Then
					$pathString = "36184527"
				ElseIf (GUICtrlRead($rotateRadio) == $GUI_CHECKED) Then
					$pathString = "14678532"
					$rotate = 1
				ElseIf (GUICtrlRead($scrambleRadio) == $GUI_CHECKED) Then
					$scramble = True
				EndIf
				If (GUICtrlRead($showRect) == $GUI_CHECKED) Then
					GUICtrlSetState($showRect, $GUI_UNCHECKED)
					$drawFrame = False
					GUIDelete($hWin)
				EndIf
				GUISetState(@SW_DISABLE, $optGUI)
				If WinExists("Processing image...") Then
					GUIDelete($GUI)
				EndIf
				$windowPos = WinGetPos($windowTitle)
				$GUI = GUICreate("Processing image...", $width, $height + 20, $windowPos[0]+$guiWidth, $windowPos[1], $WS_CAPTION, BitOR($WS_EX_APPWINDOW, $WS_EX_TOOLWINDOW))
				GUISetBkColor(0xffffff)
				$imageBox = GUICtrlCreatePic($imageFile, 0, 0, $width, $height)
				$progress = GUICtrlCreateProgress(0, $height, $width, 20)
				GUISetState()
				ProcessImage()
				GUICtrlSetState($showRect, $GUI_ENABLE)
				;UpdateConfig()
			EndIf
	EndSwitch
WEnd

;Functions to Create Rectangle Around Mouse with image size
Func _GUI_Transparent_Client($iX, $iY, $iWidth, $iHeight, $iFrameWidth = 10, $iColor = 0)
	;If $iHeight >= $iWidth Then

	;Else

	;EndIf
	;[0x000000, 0xc8b800, 0x007cc3, 0xe173df, 0xe1e1e1, 0x960000, 0x009600, 0x790098, 0xa19565]
	Local $AlphaKey = 0xa19565
	$hTGUI = GUICreate("", $iX, $iY, $iWidth, $iHeight, $WS_POPUP, $WS_EX_TOPMOST + $WS_EX_LAYERED + $WS_EX_TRANSPARENT)
	_WinAPI_SetLayeredWindowAttributes($hTGUI, $AlphaKey, 0, $LWA_COLORKEY)
	$aPos = WinGetPos($hTGUI)
	_GuiHole($hTGUI, $iFrameWidth, $iFrameWidth, $aPos[2] - 2 * $iFrameWidth, $aPos[3] - 2 * $iFrameWidth, $aPos[2], $aPos[3])
	GUISetBkColor($AlphaKey, $hTGUI)
	GUISetState()

	Return $hTGUI

EndFunc   ;==>_GUI_Transparent_Client

Func _GuiHole($h_win, $i_x, $i_y, $i_sizew, $i_sizeh, $widtht, $heightt)

	Local $outer_rgn, $inner_rgn, $combined_rgn

	$outer_rgn = _WinAPI_CreateRectRgn(0, 0, $widtht, $heightt)
	$inner_rgn = _WinAPI_CreateRectRgn(($widtht / 2 + 20), ($heightt / 2 + 20), ($widtht / 2 - 20), ($heightt / 2 - 20))
	;$inner_rgn = _WinAPI_CreateRectRgn($i_x, $i_y, $i_x + $i_sizew, $i_y + $i_sizeh)
	$combined_rgn = _WinAPI_CreateRectRgn(0, 0, 0, 0)

	_WinAPI_CombineRgn($combined_rgn, $outer_rgn, $inner_rgn, $RGN_DIFF) ;$RGN_DIFF

	_WinAPI_DeleteObject($outer_rgn)
	_WinAPI_DeleteObject($inner_rgn)

	_WinAPI_SetWindowRgn($h_win, $combined_rgn)

EndFunc   ;==>_GuiHole
Func DiffIsWithin($first,$second,$allowedDifference)
	$diff=Abs($second-$first)
	return $diff<=$allowedDifference
EndFunc
;Main Function to process the image when apply is pressed
Func ProcessImage()
	Local $hTimer = TimerInit()
	$dc = _WinAPI_GetDC($GUI)
	$memDc = _WinAPI_CreateCompatibleDC($dc)
	$bitmap = _WinAPI_CreateCompatibleBitmap($dc, $width, $height)
	_WinAPI_SelectObject($memDc, $bitmap)
	_WinAPI_BitBlt($memDc, 0, 0, $width, $height, $dc, 0, 0, $SRCCOPY)
	$bits = DllStructCreate("dword[" & ($width * $height) & "]")
	DllCall("gdi32", "int", "GetBitmapBits", "ptr", $bitmap, "int", ($width * $height * 4), "ptr", DllStructGetPtr($bits))
	GUICtrlDelete($imageBox)

	Dim $pixels[$width][$height]
	Dim $codes[$width][$height]
	$bgTolerance = GUICtrlRead($selectedTolerance)
	Local $checkJustBlack = True
	For $j = 1 To 10
		If $useColor[$j] And $checkJustBlack == True Then
			$checkJustBlack = False
		EndIf
	Next

	For $y = 0 To ($height - 1)
		For $x = 0 To ($width - 1)
			$index = ($y * $width) + $x
			$color = DllStructGetData($bits, 1, $index)
			Local $colorArray[2] = [$color, 0]
			$red = _ColorGetRed($color)
			$green = _ColorGetGreen($color)
			$blue = _ColorGetBlue($color)

			If $bgTolerance>=0 And DiffIsWithin($red,$backgroundR,$bgTolerance) And DiffIsWithin($green,$backgroundG,$bgTolerance) And DiffIsWithin($blue,$backgroundB,$bgTolerance) Then
				;TrayTip("DEBUG", $color&" "&$red&","&$green&","&$blue&" vs "&$backgroundR&","&$backgroundG&","&$backgroundB, 1)
				;ContinueLoop
				$colorArray[0] = 0xa19565
				$codes[$x][$y] = 0
			    $pixels[$x][$y] = 0
				DllStructSetData($bits, 1, $colorArray[0], $index)
			Else
				$shade = ($red + $green + $blue) / 3

				If $checkJustBlack == False Then
					$colorArray = CompareColor($red, $green, $blue)
					If ($shade > $thresholds[$colorArray[1]]) Then
						$colorArray[0] = 0xa19565
						$codes[$x][$y] = 0
						$pixels[$x][$y] = 0
					Else
						$codes[$x][$y] = GetCode($colorArray[0])
						If ($foundColors[$codes[$x][$y] - 1] == False) And ($useColor[$codes[$x][$y] - 1] == True) Then
							$foundColors[$codes[$x][$y] - 1] = True
						EndIf
						$pixels[$x][$y] = 1
					EndIf
				Else
					If ($shade > $thresholds[0]) Then
						$colorArray[0] = 0xa19565
						$codes[$x][$y] = 0
						$pixels[$x][$y] = 0
					Else
						$colorArray[0] = 0
						$foundColors[0] = True
						$codes[$x][$y] = 1
						$pixels[$x][$y] = 1
					EndIf
				EndIf
				DllStructSetData($bits, 1, $colorArray[0], $index)
			EndIf

		Next

		DllCall("gdi32", "int", "SetBitmapBits", "ptr", $bitmap, "int", ($width * $height * 4), "ptr", DllStructGetPtr($bits))
		_WinAPI_BitBlt($dc, 0, 0, $width, $height, $memDc, 0, 0, $SRCCOPY)
		GUICtrlSetData($progress, ($y * 100) / $height)
	Next

	_WinAPI_ReleaseDC($GUI, $dc)
	GUIRegisterMsg($WM_PAINT, "OnPaint")
	TrayTip("Shade Alteration Complete!", "Press F9 to lock position and draw. You can press F10 at anytime to exit. (F8 = Pause/Un-Pause After Draw Starts)", 20)
	GUISetState(@SW_ENABLE, $optGUI)

	HotKeySet("{F9}", "Draw")
	HotKeySet("{F10}", "Quit")
	Local $fDiff = TimerDiff($hTimer) ; Find the difference in time from the previous call of TimerInit. The variable we stored the TimerInit handlem is passed as the "handle" to TimerDiff.
	MsgBox($MB_SYSTEMMODAL, "Process Complete", "It took "&($fDiff/1000)&" seconds to complete")

EndFunc   ;==>ProcessImage

Func OnPaint($hwndGUI, $msgID, $wParam, $lParam)
	Local $paintStruct = DllStructCreate("hwnd hdc;int fErase;dword rcPaint[4];int fRestore;int fIncUpdate;byte rgbReserved[32]")

	$dc = DllCall("user32", "hwnd", "BeginPaint", "hwnd", $hwndGUI, "ptr", DllStructGetPtr($paintStruct))
	$dc = $dc[0]

	_WinAPI_BitBlt($dc, 0, 0, $width, $height, $memDc, 0, 0, $SRCCOPY)

	DllCall("user32", "hwnd", "EndPaint", "hwnd", $hwndGUI, "ptr", DllStructGetPtr($paintStruct))
	Return $GUI_RUNDEFMSG
EndFunc   ;==>OnPaint


;Color comparrison function using RGB -> XYZ -> LAB (much more accurate than using basic RGB color comparisson)
Func CompareColor($rVal, $gVal, $bVal)

	Local $closest = 0x000000
	Local $diffMain = 200000000
	Local $diffCompare = 0
	Local $slot = 0
	Local $rHold
	Local $gHold
	Local $bHold
	Local $lab1[3] = [0, 0, 0]

	$lab1 = rgb2lab ($rVal, $gVal, $bVal)
	For $i = 0 To 10
		$tolColorIndex = $i
		if $useColor[$i] == False Then
			$tolColorIndex = 0
		EndIf
		$lab2 = $lab2s[$tolColorIndex]
		$diffCompare = Sqrt((($lab2[0] - $lab1[0]) ^ 2) + (($lab2[1] - $lab1[1]) ^ 2) + (($lab2[2] - $lab1[2]) ^ 2))
		If $diffCompare < $diffMain Then
			$closest = $ToLColors[$i]
			$diffMain = $diffCompare
			$slot = $i
		EndIf
	Next
	Local $returnVal[2] = [$closest, $slot]
	Return $returnVal
EndFunc   ;==>CompareColor

;Code function to know which color pixels to draw each time DrawArea is called
Func GetCode($inputColor)
	Local $ToLColors[11] = [0x000000, 0xc8b800, 0x007cc3, 0xe173df, 0xe1e1e1, 0x960000, 0x009600, 0x790098, 0x808080, 0xFD8C00, 0x01CCD0] ;Black - yellow - blue - pink - white - Red - green - purple - grey - orange - teal
	Local $CodeReturn = 12
	For $i = 0 To 10
		If $inputColor == $ToLColors[$i] And $useColor[$i] Then
			$CodeReturn = $i + 1
		EndIf
	Next
	Return $CodeReturn
EndFunc   ;==>GetCode

;RGB to Lab function
Func rgb2lab($r, $g, $b)
	Local $key=$r&","&$g&","& $b
	If $rgb2LabMap.Exists($key) Then
		return $rgb2LabMap.Item($key)
	EndIf
	Local $rr = 0.0
	Local $gg = 0.0
	Local $bb = 0.0
	Local $xx = 0.0
	Local $yy = 0.0
	Local $zz = 0.0
	Local $fx = 0.0
	Local $fy = 0.0
	Local $fz = 0.0
	Local $xr = 0.0
	Local $yr = 0.0
	Local $zr = 0.0

	Local $Ls = 0.0
	Local $as = 0.0
	Local $bs = 0.0

	Local $eps = 216.0 / 24389.0
	Local $k = 24389.0 / 27.0

	Local $XXRR = 0.964221
	Local $YYRR = 1.0
	Local $ZZRR = 0.825211

	;RGB to XYZ
	$rr = $r / 255.0
	$gg = $g / 255.0
	$bb = $b / 255.0

	If $rr <= 0.04045 Then
		$rr = $rr / 12.92 ;12.92 if worse
	Else
		$rr = (($rr + 0.055) / 1.055) ^ 2.4
	EndIf

	If $gg <= 0.04045 Then
		$gg = $gg / 12.92
	Else
		$gg = (($gg + 0.055) / 1.055) ^ 2.4
	EndIf

	If $bb <= 0.04045 Then
		$bb = $bb / 12.92
	Else
		$bb = (($bb + 0.055) / 1.055) ^ 2.4
	EndIf

	$xx = 0.436052025 * $rr + 0.385081593 * $gg + 0.143087414 * $bb
	$yy = 0.222491598 * $rr + 0.71688606 * $gg + 0.060621486 * $bb
	$zz = 0.013929122 * $rr + 0.097097002 * $gg + 0.71418547 * $bb

	;XYZ to Lab
	$xr = $xx / $XXRR
	$yr = $yy / $YYRR
	$zr = $zz / $ZZRR

	If $xr > $eps Then
		$fx = $xr ^ (1 / 3)
	Else
		$fx = ($k * $xr + 16.0) / 116.0
	EndIf

	If $yr > $eps Then
		$fy = $yr ^ (1 / 3)
	Else
		$fy = ($k * $yr + 16.0) / 116.0
	EndIf

	If $zr > $eps Then
		$fz = $zr ^ (1 / 3)
	Else
		$fz = ($k * $zr + 16.0) / 116.0
	EndIf

	$Ls = (116 * $fy) - 16
	$as = 500 * ($fx - $fy)
	$bs = 200 * ($fy - $fz)

	Local $labb[3] = [0, 0, 0]
	$labb[0] = Int(2.55 * $Ls + 0.5)
	$labb[1] = Int($as + 0.5)
	$labb[2] = Int($bs + 0.5)
	$rgb2LabMap.Add($key,$labb)
	Return $labb
EndFunc   ;==>rgb2lab

;Main Draw function to split the colors up into their own groups and draw the sections accordingly
Func Draw()
	GUICtrlSetState($okBtn, $GUI_DISABLE)
	If (GUICtrlRead($showRect) == $GUI_CHECKED) Then
		GUICtrlSetState($showRect, $GUI_UNCHECKED)
		$drawFrame = False
		GUIDelete($hWin)
	EndIf
	GUICtrlSetState($showRect, $GUI_DISABLE)
	HotKeySet("{F8}", "Pause")
	HotKeySet("{F7}", "SkipNext")
	HotKeySet("{F6}", "DrawNext")
	$drawing = 1
	$mouseCenter = MouseGetPos()
	$x0 = $mouseCenter[0] - ($width / 2)
	$y0 = $mouseCenter[1] - ($height / 2)

	MouseMove($x0, $y0)
	MouseMove($x0 + $width, $y0)
	MouseMove($x0 + $width, $y0 + $height)
	MouseMove($x0, $y0 + $height)
	MouseMove($x0, $y0)

	GUIMsgBox($MB_ICONINFORMATION, "Important Information", "F8 = Pause / Unpause Draw" & @LF & @LF & "Please be sure to pause the drawing if the deathnote is about to be force closed, or if you need to be able to move the mouse!")
	$stack = CreateStack(1000)
	For $i = 1 To 10
		If $foundColors[$i] == True And $useColor[$i] == True Then
			$pixelHolder = True
			Local $noteText = $selections[$i]
			TrayTip("PRESS F7 TO SKIP COLOR!", "INFO: " & $noteText, 20)
			While ($pixelHolder)
				Sleep(100)
			WEnd
			If $skipColor == False Then
				For $y = 0 To ($height - 1)
					For $x = 0 To ($width - 1)
						If ($pixels[$x][$y] == 1 And $codes[$x][$y] == $i + 1) Then
							MouseMove($x + $x0, $y + $y0, $speed)
							Sleep(100)
							MouseDown("primary")
							DrawArea($stack, $x, $y, $x0, $y0, $codes[$x][$y])
							MouseUp("primary")
							Sleep(100)
						EndIf
					Next
				Next
			EndIf
			$skipColor = False
		EndIf
	Next
	If $foundColors[0] == True Then
		$pixelHolder = True
		Local $noteText = $selections[0]
		TrayTip("PRESS F7 TO SKIP COLOR!", "INFO: " & $noteText, 20)
		While ($pixelHolder)
			Sleep(100)
		WEnd
		If $skipColor == False Then
			For $y = 0 To ($height - 1)
				For $x = 0 To ($width - 1)
					If $pixels[$x][$y] == 1 And $codes[$x][$y] == 1 And $foundColors[0] == True Then
						MouseMove($x + $x0, $y + $y0, $speed)
						Sleep(100)
						MouseDown("primary")
						DrawArea($stack, $x, $y, $x0, $y0, $codes[$x][$y])
						MouseUp("primary")
						Sleep(100)
					EndIf
				Next
			Next
		EndIf
		$skipColor = False
	EndIf

	For $y = 0 To ($height - 1) Step 1
		For $x = 0 To ($width - 1) Step 1
			If ($pixels[$x][$y] == 2) Then
				$pixels[$x][$y] = 1
			EndIf
		Next
	Next
	$drawing = 0
	HotKeySet("{F8}")
	HotKeySet("{F7}")
	HotKeySet("{F6}")
	TrayTip("Status:", "Completed. Press F10 to Exit, F9 to Draw Again.", 20)
	GUICtrlSetState($showRect, $GUI_ENABLE)
	GUICtrlSetState($okBtn, $GUI_ENABLE)
EndFunc   ;==>Draw

;DrawArea function to group the pixels based on the pathing type, and move the mouse to those pixels depending on pattern selection
Func DrawArea(ByRef $stack, $x, $y, $x0, $y0, $currentCode)
	Local $path[8]
	Local $continue
	Local $delaycount = 0

	$path = MakePath($pathString)

	While 1
		If ($delaycount == $speedMouse) Then
			Sleep(10)
			$delaycount = 0
		Else
			$delaycount += 1
		EndIf
		MouseMove($x + $x0, $y + $y0, $speed)
		$pixels[$x][$y] = 2

		If ($scramble) Then ScramblePath($path)
		If ($rotate > 0) Then RotatePath($path, $rotate)

		$continue = False
		For $i = 0 To 7
			Switch ($path[$i])
				Case 1
					If (($x > 0) And ($y > 0)) Then
						If ($pixels[$x - 1][$y - 1] == 1 And $codes[$x - 1][$y - 1] == $currentCode) Then
							Push($stack, $x, $y)
							$x -= 1
							$y -= 1
							$continue = True
							ExitLoop
						EndIf
					EndIf

				Case 2
					If ($y > 0) Then
						If ($pixels[$x][$y - 1] == 1 And $codes[$x][$y - 1] == $currentCode) Then
							Push($stack, $x, $y)
							$y -= 1
							$continue = True
							ExitLoop
						EndIf
					EndIf

				Case 3
					If (($x > 0) And ($y < 0)) Then
						If ($pixels[$x + 1][$y - 1] == 1 And $codes[$x + 1][$y - 1] == $currentCode) Then
							Push($stack, $x, $y)
							$x += 1
							$y -= 1
							$continue = True
							ExitLoop
						EndIf
					EndIf

				Case 4
					If ($x > 0) Then
						If ($pixels[$x - 1][$y] == 1 And $codes[$x - 1][$y] == $currentCode) Then
							Push($stack, $x, $y)
							$x -= 1
							$continue = True
							ExitLoop
						EndIf
					EndIf

				Case 5
					If ($x < ($width - 1)) Then
						If ($pixels[$x + 1][$y] == 1 And $codes[$x + 1][$y] == $currentCode) Then
							Push($stack, $x, $y)
							$x += 1
							$continue = True
							ExitLoop
						EndIf
					EndIf

				Case 6
					If (($x < 0) And ($y > 0)) Then
						If ($pixels[$x - 1][$y + 1] == 1 And $codes[$x - 1][$y + 1] == $currentCode) Then
							Push($stack, $x, $y)
							$x -= 1
							$y += 1
							$continue = True
							ExitLoop
						EndIf
					EndIf

				Case 7
					If ($y < ($height - 1)) Then
						If ($pixels[$x][$y + 1] == 1 And $codes[$x][$y + 1] == $currentCode) Then
							Push($stack, $x, $y)
							$y += 1
							$continue = True
							ExitLoop
						EndIf
					EndIf

				Case 8
					If (($x < ($width - 1)) And ($y < ($height - 1))) Then
						If ($pixels[$x + 1][$y + 1] == 1 And $codes[$x + 1][$y + 1] == $currentCode) Then
							Push($stack, $x, $y)
							$x += 1
							$y += 1
							$continue = True
							ExitLoop
						EndIf
					EndIf
			EndSwitch
		Next
		If ($continue) Then ContinueLoop
		If (Not Pop($stack, $x, $y)) Then ExitLoop
	WEnd
EndFunc   ;==>DrawArea

;convert the string of numbers to a array of numbers
Func MakePath($string)
	Return StringSplit($string, "")
EndFunc   ;==>MakePath

;randomize the path (for random pattern)
Func ScramblePath(ByRef $path)
	Local $table = "12345678"
	Local $newPath[8]

	For $i = 8 To 1 Step -1
		$next = StringMid($table, Random(1, $i, 1), 1)
		$newPath[$i - 1] = Number($next)
		$table = StringReplace($table, $next, "")
	Next
	$path = $newPath
EndFunc   ;==>ScramblePath

;set the path to a circle pattern, outside -> inwards
Func RotatePath(ByRef $path, $places)
	If ($places == 0) Then
		Return $path
	Else
		For $i = 1 To Abs($places)
			$temp = $path[7]
			$path[7] = $path[6]
			$path[6] = $path[5]
			$path[5] = $path[4]
			$path[4] = $path[3]
			$path[3] = $path[2]
			$path[2] = $path[1]
			$path[1] = $path[0]
			$path[0] = $temp
		Next
	EndIf
EndFunc   ;==>RotatePath

;create stack lol (self explainitory)
Func CreateStack($size)
	Dim $stack[$size + 1][2]
	$stack[0][0] = 0
	$stack[0][1] = $size
	Return $stack
EndFunc   ;==>CreateStack

;push the stack
Func Push(ByRef $stack, $x, $y)
	$stack[0][0] += 1
	If ($stack[0][0] > $stack[0][1]) Then
		$stack[0][1] += 1000
		ReDim $stack[$stack[0][1] + 1][2]
	EndIf

	$stack[$stack[0][0]][0] = $x
	$stack[$stack[0][0]][1] = $y
EndFunc   ;==>Push

;pop the stack
Func Pop(ByRef $stack, ByRef $x, ByRef $y)
	If ($stack[0][0] < 1) Then
		Return False
	EndIf

	$x = $stack[$stack[0][0]][0]
	$y = $stack[$stack[0][0]][1]

	$stack[0][0] -= 1
	Return True
EndFunc   ;==>Pop

;function to start drawing the next color
Func DrawNext()
	$pixelHolder = False
EndFunc   ;==>DrawNext

;function to prevent program from running if hotkeys cannot be bound
Func Nothing()
EndFunc   ;==>Nothing

;Determines if the mouse is in the given x,y coord or not. Returns 1 if true, 0 if false.
Func MouseIsInPosition($x, $y)
	$mouseloca = MouseGetPos()
	$currX = $mouseloca[0]
	$currY = $mouseloca[1]
	If ($currX == $x And $currY == $y) Then
		;return 1/true
		Return 1
	EndIf
	;otherwise return 0/false
	Return 0
EndFunc   ;==>MouseIsInPosition

;function to pause and unpause the drawing (example is in ToL if the night is about to end, pause, so when a log appears it doesnt keep drawing thinking the deathnote is still open)
Func Pause()
	If ($drawing == 1) Then
		$scriptPause = Not $scriptPause

		If ($scriptPause) Then
			$mouseloca = MouseGetPos()
			$mousePressed = _IsPressed(01)
			MouseUp("primary")
			$mouselocaPrevious = $mouseloca
			TrayTip("* Paused *", 'Script is "Paused", Press F8 to resume', 20)
		Else
			TrayTip("* UNPaused *", 'Script is Live again.', 40)
			MouseUp("primary")
			;move our move into position, most computers will be near instant, but some may not.
			While Not MouseIsInPosition($mouselocaPrevious[0], $mouselocaPrevious[1])
				MouseMove($mouselocaPrevious[0], $mouselocaPrevious[1], $speed)
				Sleep(10)
			WEnd
			if $mousePressed then
				MouseDown("primary")
			Else
				MouseUp("primary")
			EndIf
		EndIf
		While $scriptPause
			Switch (GUIGetMsg())
				Case $GUI_EVENT_CLOSE, $exitBtn
					Exit
				Case $resetBtn
					HotKeySet("{F9}")
					HotKeySet("{F10}")
					HotKeySet("{F8}")
					HotKeySet("{F7}")
					HotKeySet("{F6}")
					If @Compiled Then
						ShellExecute(@ScriptFullPath)
					Else
						ShellExecute(@AutoItExe, @ScriptFullPath)
					EndIf
					Exit
			EndSwitch
			;Sleep(100)
		WEnd
		;TrayTip("Drawing Resumed!", "Script is now continuing to draw.", 20)
	Else
		TrayTip("ERROR", "Script must be drawing in order to pause.", 20)
	EndIf
EndFunc   ;==>Pause

;function to skip the next color if you realize you dont want to draw that color and dont want to reprocess the image with the color disabled
Func SkipNext()
	$skipColor = True
	$pixelHolder = False
EndFunc   ;==>SkipNext


Func AddGUINumberField($label, $defaultValue, $disabled)

	GUICtrlCreateLabel($label, $flexX, $flexY, $guiWidth/4, $fieldHeight)
	GUICtrlSetFont(-1, 10)
	GUICtrlSetResizing(-1, $GUI_DOCKALL)

	$left = $flexX+($guiWidth/4)
	$top = $flexY
	$flexY += $fieldHeight+$padding
	$newField = GUICtrlCreateInput($defaultValue, $left, $top, ($guiWidth/4) - ($padding *4), $fieldHeight, $ES_NUMBER)
	If $disabled Then
		GUICtrlSetState(-1, $GUI_DISABLE)
	EndIf

	GUICtrlSetFont(-1, 10)
	GUICtrlSetResizing(-1, $GUI_DOCKALL)
	return $newField
EndFunc

Func AddGUITextField($label, $defaultValue, $disabled)

	GUICtrlCreateLabel($label, $flexX, $flexY, $guiWidth/4, $fieldHeight)
	GUICtrlSetFont(-1, 10)
	GUICtrlSetResizing(-1, $GUI_DOCKALL)

	$left = $flexX+($guiWidth/4)
	$top = $flexY
	$flexY += $fieldHeight+$padding
	$newField = GUICtrlCreateInput($defaultValue, $left, $top, ($guiWidth/4) - ($padding *4), $fieldHeight)
	If $disabled Then
		GUICtrlSetState(-1, $GUI_DISABLE)
	EndIf

	GUICtrlSetFont(-1, 10)
	GUICtrlSetResizing(-1, $GUI_DOCKALL)
	return $newField
EndFunc

Func AddGUICheckboxField($label, $disabled)

	$left = $flexX
	$top = $flexY
	$newField = GUICtrlCreateCheckbox($label, $left, $top, ($guiWidth/2) - ($padding *4), $fieldHeight, BitOR($GUI_SS_DEFAULT_CHECKBOX, $BS_RIGHTBUTTON))

	$flexY += $fieldHeight+$padding
	If $disabled Then
		GUICtrlSetState(-1, $GUI_DISABLE)
	EndIf
	GUICtrlSetFont(-1, 10)
	GUICtrlSetResizing(-1, $GUI_DOCKALL)
	return $newField
EndFunc

Func AddGUIColorCheckboxField($label, $disabled, $color)

	$left = $flexX
	$top = $flexY
	GUICtrlCreateGraphic($left, $top, 24, 24)
	GUICtrlSetBkColor(-1, $color)
	GUICtrlSetResizing (-1, $GUI_DOCKALL)
	$left += 24 + $padding
	$newField = GUICtrlCreateCheckbox($label, $left, $top, ($guiWidth/2) - ($padding *5) - 24, $fieldHeight, BitOR($GUI_SS_DEFAULT_CHECKBOX, $BS_RIGHTBUTTON))

	$flexY += $fieldHeight+$padding
	If $disabled Then
		GUICtrlSetState(-1, $GUI_DISABLE)
	EndIf
	GUICtrlSetFont(-1, 10)
	GUICtrlSetResizing(-1, $GUI_DOCKALL)
	return $newField
EndFunc


Func AddGUILabelField($label)

	$left = $flexX
	$top = $flexY
	$newField = GUICtrlCreateLabel($label, $left, $top,  ($guiWidth/2) - ($padding *4), $fieldHeight)

	$flexY += $fieldHeight+$padding
	GUICtrlSetColor(-1, 0x960000)
	GUICtrlSetFont(-1, 10)
	GUICtrlSetResizing(-1, $GUI_DOCKALL)
	return $newField
EndFunc

Func AddGUIRadioField($label)

	$left = $flexX
	$top = $flexY
	$newField = GUICtrlCreateRadio($label, $left, $top,  ($guiWidth/2) - ($padding *4), $fieldHeight)

	$flexY += $fieldHeight+$padding
	GUICtrlSetFont(-1, 10)
	GUICtrlSetResizing(-1, $GUI_DOCKALL)
	return $newField
EndFunc

Func AddGUIButton($label)

	$left = $flexX
	$top = $flexY
	$newField = GUICtrlCreateButton($label, $left, $top,  ($guiWidth/2) - ($padding *4), $fieldHeight)

	GUICtrlSetFont(-1, 10)
	GUICtrlSetResizing(-1, $GUI_DOCKALL)
	return $newField
EndFunc

;i'm not even sure i need to bother commenting this one...
Func Quit()
	MouseUp("primary")
	UpdateConfig()
	Exit
EndFunc   ;==>Quit
