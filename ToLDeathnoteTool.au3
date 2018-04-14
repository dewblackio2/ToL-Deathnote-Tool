#cs

  _______    _        _____             _   _                 _         _______          _
 |__   __|  | |      |  __ \           | | | |               | |       |__   __|        | |
    | | ___ | |      | |  | | ___  __ _| |_| |__  _ __   ___ | |_ ___     | | ___   ___ | |
    | |/ _ \| |      | |  | |/ _ \/ _` | __| '_ \| '_ \ / _ \| __/ _ \    | |/ _ \ / _ \| |
    | | (_) | |____  | |__| |  __/ (_| | |_| | | | | | | (_) | ||  __/    | | (_) | (_) | |
    |_|\___/|______| |_____/ \___|\__,_|\__|_| |_|_| |_|\___/ \__\___|    |_|\___/ \___/|_|


				   ___      _   ___             _    _         _   _     ___
				  | _ )_  _(_) |   \ _____ __ _| |__| |__ _ __| |_(_)___|_  )
				  | _ \ || |_  | |) / -_) V  V / '_ \ / _` / _| / / / _ \/ /
				  |___/\_, (_) |___/\___|\_/\_/|_.__/_\__,_\__|_\_\_\___/___|
					 |__/

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

MsgBox($MB_ICONWARNING, "Warning", "Using this software to draw any form of obscurities or NSFW content on your deathnote, will result in a flag against your Throne of Lies account and may result in a permanent suspension. By using this application, you agree to these terms.")

;Initialize Global Variables
Global $hWin
Global $aPos
Global $imageBox
Global $GUI
Global $bPos
Global $dc
Global $memDc
Global $bitmap
Global $bits
Global $drawFrame = false
Global $drawing = 0
Global $thresholds[8] = [0, 0, 0, 0, 0, 0, 0, 0]
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
Global $mouseloca = MouseGetPos()
Global $useColor[9] = [true, false, false, false, false, false, false, false, false]
Global $foundColors[9] = [false, false, false, false, false, false, false, false, false]
Global $selections[8] = ["Please Select BLACK for draw color then press F6 to continue!", "Please Select YELLOW for draw color then press F6 to continue!", "Please Select BLUE for draw color then press F6 to continue!", "Please Select PINK for draw color then press F6 to continue!", "Please Select WHITE for draw color then press F6 to continue!", "Please Select RED for draw color then press F6 to continue!", "Please Select GREEN for draw color then press F6 to continue!", "Please Select PURPLE for draw color then press F6 to continue!"];yellow - blue - pink - white - Red - green - purple
Global $pixelHolder = False
Global $skipColor = False

;prevent program from running if main hotkeys are bound to something
If (Not HotKeySet ("{F9}", "Nothing")) Then
   MsgBox (16, "Error", "Could not register the F9 hotkey.")
   Exit
EndIf
If (Not HotKeySet ("{F10}", "Nothing")) Then
   MsgBox (16, "Error", "Could not register the F10 hotkey.")
   Exit
EndIf
If (Not HotKeySet ("{F8}", "Nothing")) Then
   MsgBox (16, "Error", "Could not register the F8 hotkey.")
   Exit
 EndIf
If (Not HotKeySet ("{F7}", "Nothing")) Then
   MsgBox (16, "Error", "Could not register the F7 hotkey.")
   Exit
EndIf
If (Not HotKeySet ("{F6}", "Nothing")) Then
   MsgBox (16, "Error", "Could not register the F6 hotkey.")
   Exit
EndIf

;[] Main Settings Window [] (i never want to make a GUI by hand ever again -.-)
$optGUI = GUICreate ("ToL Deathnote Tool", 1000, 700, -1, -1, -1)

$imageDisplay = GUICtrlCreatePic ("", 480, 16, 500, 600, $WS_BORDER)
$donateBtn = GUICtrlCreateButton("♥♥ Donate To Support My Work ♥♥", 480, 640, 500, 35)
GUICtrlSetFont(-1, 12)

GUICtrlCreateGroup("Image Settings", 16, 16, 185, 185, BitOR ($GUI_SS_DEFAULT_GROUP,$BS_CENTER)) ;width height and option to show picture size around mouse once processing done
GUICtrlSetFont(-1, 10)
GUICtrlSetResizing (-1, $GUI_DOCKALL)
GUICtrlCreateLabel("Width (px):", 24, 45, 80, 25)
GUICtrlSetFont(-1, 10)
GUICtrlSetResizing (-1, $GUI_DOCKALL)
$widthInput = GUICtrlCreateInput ("500", 120, 45, 50, 20, $ES_NUMBER)
GUICtrlSetResizing (-1, $GUI_DOCKALL)
GUICtrlCreateLabel("Height (px):", 24, 85, 80, 25)
GUICtrlSetFont(-1, 10)
GUICtrlSetResizing (-1, $GUI_DOCKALL)
$heightInput = GUICtrlCreateInput ("600", 120, 85, 50, 20, $ES_NUMBER)
GUICtrlSetResizing (-1, $GUI_DOCKALL)
$showRect = GUICtrlCreateCheckbox ("Draw Image Size? ", 24, 125, 135, 25, BitOR ($GUI_SS_DEFAULT_CHECKBOX,$BS_RIGHTBUTTON))
GUICtrlSetFont($showRect, 10)
GUICtrlSetResizing (-1, $GUI_DOCKALL)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlCreateLabel("(Un-Check/Re-Check to Refresh Rectangle Width/Height)", 24, 155, 170, 30)
GUICtrlSetColor(-1, 0x960000)
GUICtrlSetResizing (-1, $GUI_DOCKALL)
GUICtrlCreateGroup("", -99, -99, 1, 1)

GUICtrlCreateGroup("Drawing Settings", 16, 224, 185, 249, BitOR ($GUI_SS_DEFAULT_GROUP,$BS_CENTER)) ;Drawing pattern and mouse speed settings
GUICtrlSetFont(-1, 10)
GUICtrlSetResizing (-1, $GUI_DOCKALL)
GUICtrlCreateLabel ("Pattern:", 24, 240, 135, 20)
GUICtrlSetFont(-1, 10, 400, 4)
GUICtrlSetResizing (-1, $GUI_DOCKALL)
$horizontalRadio = GUICtrlCreateRadio (" Horizontal", 24, 255, 135, 25)
GUICtrlSetFont(-1, 10)
GUICtrlSetResizing (-1, $GUI_DOCKALL)
$verticalRadio = GUICtrlCreateRadio (" Vertical", 24, 280, 135, 25)
GUICtrlSetFont(-1, 10)
GUICtrlSetResizing (-1, $GUI_DOCKALL)
$diagonalRadio = GUICtrlCreateRadio (" Diagonal", 24, 305, 135, 25)
GUICtrlSetFont(-1, 10)
GUICtrlSetResizing (-1, $GUI_DOCKALL)
$rotateRadio = GUICtrlCreateRadio (" Spiral", 24, 330, 135, 25)
GUICtrlSetFont(-1, 10)
GUICtrlSetResizing (-1, $GUI_DOCKALL)
$scrambleRadio = GUICtrlCreateRadio (" Random", 24, 355, 135, 25)
GUICtrlSetFont(-1, 10)
GUICtrlSetResizing (-1, $GUI_DOCKALL)
GUICtrlSetState ($diagonalRadio, $GUI_CHECKED)
GUICtrlCreateLabel ("Speed:", 24, 380, 135, 20)
GUICtrlSetFont(-1, 10, 400, 4)
GUICtrlSetResizing (-1, $GUI_DOCKALL)
GUICtrlCreateLabel ("Mouse speed:", 24, 405, 90, 25)
GUICtrlSetFont(-1, 10)
GUICtrlSetResizing (-1, $GUI_DOCKALL)
$speedInput = GUICtrlCreateInput ("5", 120, 405, 50, 20, $ES_NUMBER)
GUICtrlSetResizing (-1, $GUI_DOCKALL)
GUICtrlCreateLabel ("0 = Slow and Accurate", 24, 430, 135, 15)
GUICtrlSetFont(-1, 10)
GUICtrlSetResizing (-1, $GUI_DOCKALL)
GUICtrlCreateLabel ("100 = Fast but Sloppy", 24, 450, 135, 20)
GUICtrlSetFont(-1, 10)
GUICtrlSetResizing (-1, $GUI_DOCKALL)
GUICtrlCreateGroup("", -99, -99, 1, 1)

GUICtrlCreateGroup("Color Settings", 232, 16, 217, 567, BitOR ($GUI_SS_DEFAULT_GROUP,$BS_CENTER)) ;color settings and threshold modification
GUICtrlSetFont(-1, 10)
GUICtrlSetResizing (-1, $GUI_DOCKALL)
GUICtrlCreateGroup("Black", 232, 40, 217, 49)
GUICtrlSetResizing (-1, $GUI_DOCKALL)
GUICtrlCreateGraphic(245, 60, 24, 24)
GUICtrlSetBkColor(-1, 0x000000)
GUICtrlSetResizing (-1, $GUI_DOCKALL)
GUICtrlCreateLabel("Threshold (0-255): ", 284, 62, 90, 20)
GUICtrlSetResizing (-1, $GUI_DOCKALL)
$blackThresh = GUICtrlCreateInput("100", 375, 59, 49, 24, $ES_NUMBER)
GUICtrlSetResizing (-1, $GUI_DOCKALL)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlCreateLabel("Using Colors Takes Longer!", 240, 96, 197, 20)
GUICtrlSetFont(-1, 10, 800, 4, "MS Sans Serif")
GUICtrlSetResizing (-1, $GUI_DOCKALL)
GUICtrlCreateGroup("Yellow", 232, 120, 217, 73)
GUICtrlSetResizing (-1, $GUI_DOCKALL)
GUICtrlCreateGraphic(245, 140, 24, 24)
GUICtrlSetBkColor(-1, 0xc8b800)
GUICtrlSetResizing (-1, $GUI_DOCKALL)
$yellowDet = GUICtrlCreateCheckbox("Enabled", 288, 168, 60, 17, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_RIGHTBUTTON))
GUICtrlSetResizing (-1, $GUI_DOCKALL)
GUICtrlCreateLabel("Threshold (0-255): ", 284, 142, 90, 20)
GUICtrlSetResizing (-1, $GUI_DOCKALL)
$yellowThresh = GUICtrlCreateInput("255", 375, 139, 49, 24, $ES_NUMBER)
GUICtrlSetResizing (-1, $GUI_DOCKALL)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlCreateGroup("Blue", 232, 185, 217, 73)
GUICtrlSetResizing (-1, $GUI_DOCKALL)
GUICtrlCreateGraphic(245, 205, 24, 24)
GUICtrlSetBkColor(-1, 0x007cc3)
GUICtrlSetResizing (-1, $GUI_DOCKALL)
$blueDet = GUICtrlCreateCheckbox("Enabled", 288, 233, 60, 17, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_RIGHTBUTTON))
GUICtrlSetResizing (-1, $GUI_DOCKALL)
GUICtrlCreateLabel("Threshold (0-255): ", 284, 207, 90, 20)
GUICtrlSetResizing (-1, $GUI_DOCKALL)
$blueThresh = GUICtrlCreateInput("255", 375, 204, 49, 24, $ES_NUMBER)
GUICtrlSetResizing (-1, $GUI_DOCKALL)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlCreateGroup("Pink", 232, 250, 217, 73)
GUICtrlSetResizing (-1, $GUI_DOCKALL)
GUICtrlCreateGraphic(245, 270, 24, 24)
GUICtrlSetBkColor(-1, 0xe173df)
GUICtrlSetResizing (-1, $GUI_DOCKALL)
$pinkDet = GUICtrlCreateCheckbox("Enabled", 288, 298, 60, 17, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_RIGHTBUTTON))
GUICtrlSetResizing (-1, $GUI_DOCKALL)
GUICtrlCreateLabel("Threshold (0-255): ", 284, 272, 90, 20)
GUICtrlSetResizing (-1, $GUI_DOCKALL)
$pinkThresh = GUICtrlCreateInput("255", 375, 269, 49, 24, $ES_NUMBER)
GUICtrlSetResizing (-1, $GUI_DOCKALL)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlCreateGroup("White", 232, 315, 217, 73)
GUICtrlSetResizing (-1, $GUI_DOCKALL)
GUICtrlCreateGraphic(245, 335, 24, 24)
GUICtrlSetBkColor(-1, 0xe1e1e1)
GUICtrlSetResizing (-1, $GUI_DOCKALL)
$whiteDet = GUICtrlCreateCheckbox("Enabled", 288, 363, 60, 17, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_RIGHTBUTTON))
GUICtrlSetResizing (-1, $GUI_DOCKALL)
GUICtrlCreateLabel("Threshold (0-255): ", 284, 337, 90, 20)
GUICtrlSetResizing (-1, $GUI_DOCKALL)
$whiteThresh = GUICtrlCreateInput("255", 375, 334, 49, 24, $ES_NUMBER)
GUICtrlSetResizing (-1, $GUI_DOCKALL)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlCreateGroup("Red", 232, 380, 217, 73)
GUICtrlSetResizing (-1, $GUI_DOCKALL)
GUICtrlCreateGraphic(245, 400, 24, 24)
GUICtrlSetBkColor(-1, 0x960000)
GUICtrlSetResizing (-1, $GUI_DOCKALL)
$redDet = GUICtrlCreateCheckbox("Enabled", 288, 428, 60, 17, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_RIGHTBUTTON))
GUICtrlSetResizing (-1, $GUI_DOCKALL)
GUICtrlCreateLabel("Threshold (0-255): ", 284, 402, 90, 20)
GUICtrlSetResizing (-1, $GUI_DOCKALL)
$redThresh = GUICtrlCreateInput("255", 375, 399, 49, 24, $ES_NUMBER)
GUICtrlSetResizing (-1, $GUI_DOCKALL)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlCreateGroup("Green", 232, 445, 217, 73)
GUICtrlSetResizing (-1, $GUI_DOCKALL)
GUICtrlCreateGraphic(245, 465, 24, 24)
GUICtrlSetBkColor(-1, 0x009600)
GUICtrlSetResizing (-1, $GUI_DOCKALL)
$greenDet = GUICtrlCreateCheckbox("Enabled", 288, 493, 60, 17, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_RIGHTBUTTON))
GUICtrlSetResizing (-1, $GUI_DOCKALL)
GUICtrlCreateLabel("Threshold (0-255): ", 284, 467, 90, 20)
GUICtrlSetResizing (-1, $GUI_DOCKALL)
$greenThresh = GUICtrlCreateInput("255", 375, 464, 49, 24, $ES_NUMBER)
GUICtrlSetResizing (-1, $GUI_DOCKALL)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlCreateGroup("Purple", 232, 510, 217, 73)
GUICtrlSetResizing (-1, $GUI_DOCKALL)
GUICtrlCreateGraphic(245, 530, 24, 24)
GUICtrlSetBkColor(-1, 0x790098)
GUICtrlSetResizing (-1, $GUI_DOCKALL)
$purpleDet = GUICtrlCreateCheckbox("Enabled", 288, 558, 60, 17, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_RIGHTBUTTON))
GUICtrlSetResizing (-1, $GUI_DOCKALL)
GUICtrlCreateLabel("Threshold (0-255): ", 284, 532, 90, 20)
GUICtrlSetResizing (-1, $GUI_DOCKALL)
$purpleThresh = GUICtrlCreateInput("255", 375, 529, 49, 24, $ES_NUMBER)
GUICtrlSetResizing (-1, $GUI_DOCKALL)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlCreateGroup("", -99, -99, 1, 1)

GUICtrlCreateGroup("Keybinds", 16, 488, 201, 137, BitOR ($GUI_SS_DEFAULT_GROUP,$BS_CENTER)) ;Keybinds and credits
GUICtrlSetFont(-1, 10)
GUICtrlSetResizing (-1, $GUI_DOCKALL)
GUICtrlCreateLabel("F9 = Start! and Lock Pos", 24, 504, 147, 20)
GUICtrlSetFont(-1, 10)
GUICtrlSetResizing (-1, $GUI_DOCKALL)
GUICtrlCreateLabel("F6 = Draw Current Color", 24, 528, 143, 20)
GUICtrlSetFont(-1, 10)
GUICtrlSetResizing (-1, $GUI_DOCKALL)
GUICtrlCreateLabel("F7 = Skip Current Color", 24, 552, 139, 20)
GUICtrlSetFont(-1, 10)
GUICtrlSetResizing (-1, $GUI_DOCKALL)
GUICtrlCreateLabel("F10 = Exit Program", 24, 600, 115, 20)
GUICtrlSetFont(-1, 10)
GUICtrlSetResizing (-1, $GUI_DOCKALL)
GUICtrlCreateLabel("F8 = Pause / Resume Draw", 24, 576, 166, 20)
GUICtrlSetFont(-1, 10)
GUICtrlSetResizing (-1, $GUI_DOCKALL)
GUICtrlCreateGroup("", -99, -99, 1, 1)

GUICtrlCreateLabel("Throne of Lies Deathnote Tool", 232, 584, 218, 21)
GUICtrlSetFont(-1, 12, 400, 0, "Britannic Bold")
GUICtrlSetResizing (-1, $GUI_DOCKALL)
GUICtrlCreateLabel("Created By: Dewblackio2", 248, 608, 181, 21)
GUICtrlSetFont(-1, 12, 400, 0, "Britannic Bold")
GUICtrlSetResizing (-1, $GUI_DOCKALL)

$openBtn = GUICtrlCreateButton("Open", 16, 640, 99, 33) ;open image, all buttons disabled until image loaded
GUICtrlSetResizing (-1, $GUI_DOCKALL)
$okBtn = GUICtrlCreateButton("Apply", 128, 640, 99, 33) ;Apply
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetResizing (-1, $GUI_DOCKALL)
$resetBtn = GUICtrlCreateButton("Reset", 240, 640, 99, 33) ;Reset
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetResizing (-1, $GUI_DOCKALL)
$exitBtn = GUICtrlCreateButton("Exit", 352, 640, 99, 33) ;Exit
GUICtrlSetResizing (-1, $GUI_DOCKALL)
GUISetState ()

;Main Gui Control Messages
While 1
   If $drawFrame == true Then
	  Sleep(10)
	  $aMouse = MouseGetPos()
	  WinMove($hWin, "", $aMouse[0] - $aPos[2] / 2, $aMouse[1] - $aPos[3] / 2)
   EndIf
   Switch (GUIGetMsg ())
	  Case $GUI_EVENT_CLOSE, $exitBtn
		 Exit
	  Case $donateBtn
		 Shellexecute("http://www.paypal.me/Dewblackio2")
	  Case $openBtn
		 $imageFile = FileOpenDialog ("Open Image", @WorkingDir, "Images (*.jpg;*.jpeg;*.gif;*.bmp)", 1) ;png is not supported in auto it function :c
		 If (@error) Then Exit
		 GUICtrlSetImage ($imageDisplay, $imageFile)
		 GUICtrlSetState($openBtn, $GUI_DISABLE)
		 GUICtrlSetState($okBtn, $GUI_ENABLE)
		 GUICtrlSetState($showRect, $GUI_ENABLE)
		 GUICtrlSetState($resetBtn, $GUI_ENABLE)
	  Case $showRect
		 If (GUICtrlRead ($showRect) == $GUI_CHECKED) And $drawing == 0 And $drawFrame == false Then
			$hWin = _GUI_Transparent_Client(GUICtrlRead ($widthInput), GUICtrlRead ($heightInput), -1, -1, 5, 0xFF0000)
			$aPos = WinGetPos($hWin)
			$drawFrame = True
			;GUISetState(@SW_SHOW, $hWin)
		 ElseIf ((GUICtrlRead ($showRect) <> $GUI_CHECKED) Or $drawing == 1) And $drawFrame == true Then
			$drawFrame = False
			GUIDelete ($hWin)
			;GUISetState(@SW_HIDE, $hWin)
			If (GUICtrlRead ($showRect) == $GUI_CHECKED) Then
			   GUICtrlSetState ($showRect, $GUI_UNCHECKED)
			EndIf
		 EndIf
	  Case $resetBtn
		 HotKeySet ("{F9}")
		 HotKeySet ("{F10}")
		 HotKeySet ("{F8}")
		 HotKeySet ("{F7}")
		 HotKeySet ("{F6}")
		 If @Compiled Then
			ShellExecute(@ScriptFullPath)
		 Else
			ShellExecute(@AutoItExe, @ScriptFullPath)
		 EndIf
		 Exit
	  Case $okBtn
		 HotKeySet ("{F9}")
		 HotKeySet ("{F10}")
		 HotKeySet ("{F8}")
		 HotKeySet ("{F7}")
		 HotKeySet ("{F6}")
		 $pixelHolder = False
		 $skipColor = False
		 $scriptPause = False
		 $drawing = 0
		 $bPos = WinGetPos($optGUI)
		 GUICtrlDelete($imageDisplay)
		 GUICtrlDelete($donateBtn)
		 WinMove($optGUI, "", $bPos[0], $bPos[1], 500, 729)
		 For $j = 1 To 8
			$useColor[$j] = false
		 Next
		 For $n = 0 To 8
			$foundColors[$n] = false
		 Next
		 $thresholds[0] = GUICtrlRead ($blackThresh)
		 $thresholds[1] = GUICtrlRead ($yellowThresh)
		 $thresholds[2] = GUICtrlRead ($blueThresh)
		 $thresholds[3] = GUICtrlRead ($pinkThresh)
		 $thresholds[4] = GUICtrlRead ($whiteThresh)
		 $thresholds[5] = GUICtrlRead ($redThresh)
		 $thresholds[6] = GUICtrlRead ($greenThresh)
		 $thresholds[7] = GUICtrlRead ($purpleThresh)
		 $width = GUICtrlRead ($widthInput)
		 $height = GUICtrlRead ($heightInput)
		 $speedMouse = GUICtrlRead ($speedInput)
		 If (GUICtrlRead ($yellowDet) == $GUI_CHECKED) Then
			$useColor[1] = true
		 EndIf
		 If (GUICtrlRead ($blueDet) == $GUI_CHECKED) Then
			$useColor[2] = true
		 EndIf
		 If (GUICtrlRead ($pinkDet) == $GUI_CHECKED) Then
			$useColor[3] = true
		 EndIf
		 If (GUICtrlRead ($whiteDet) == $GUI_CHECKED) Then
			$useColor[4] = true
		 EndIf
		 If (GUICtrlRead ($redDet) == $GUI_CHECKED) Then
			$useColor[5] = true
		 EndIf
		 If (GUICtrlRead ($greenDet) == $GUI_CHECKED) Then
			$useColor[6] = true
		 EndIf
		 If (GUICtrlRead ($purpleDet) == $GUI_CHECKED) Then
			$useColor[7] = true
		 EndIf
		 If	(GUICtrlRead ($horizontalRadio) == $GUI_CHECKED) Then
			$pathString = "45273618"
		 ElseIf (GUICtrlRead ($verticalRadio) == $GUI_CHECKED) Then
			$pathString = "27453618"
		 ElseIf (GUICtrlRead ($diagonalRadio) == $GUI_CHECKED) Then
			$pathString = "36184527"
		 ElseIf (GUICtrlRead ($rotateRadio) == $GUI_CHECKED) Then
			$pathString = "14678532"
			$rotate = 1
		 ElseIf (GUICtrlRead ($scrambleRadio) == $GUI_CHECKED) Then
			$scramble = True
		 EndIf
		 If (GUICtrlRead ($showRect) == $GUI_CHECKED) Then
			GUICtrlSetState ($showRect, $GUI_UNCHECKED)
			$drawFrame = False
			GUIDelete ($hWin)
		 EndIf
		 GUISetState (@SW_DISABLE, $optGUI)
		 If WinExists("Processing image...") Then
			GUIDelete($GUI)
		 EndIf

		 $GUI = GUICreate ("Processing image...", $width, $height + 20, -1, -1, $WS_CAPTION, BitOr ($WS_EX_APPWINDOW, $WS_EX_TOOLWINDOW))
		 GUISetBkColor (0xffffff)
		 $imageBox = GUICtrlCreatePic ($imageFile, 0, 0, $width, $height)
		 $progress = GUICtrlCreateProgress (0, $height, $width, 20)
		 GUISetState ()
		 ProcessImage()
   EndSwitch
WEnd

;Functions to Create Rectangle Around Mouse with image size
Func _GUI_Transparent_Client($iX, $iY, $iWidth, $iHeight, $iFrameWidth = 10, $iColor = 0)

$hTGUI = GUICreate("", $iX, $iY, $iWidth, $iHeight, $WS_POPUP, $WS_EX_TOPMOST)
$aPos = WinGetPos($hTGUI)
_GuiHole($hTGUI, $iFrameWidth, $iFrameWidth, $aPos[2] - 2 * $iFrameWidth, $aPos[3] - 2 * $iFrameWidth, $aPos[2], $aPos[3])
GUISetBkColor($iColor)
GUISetState()

Return $hTGUI

EndFunc

Func _GuiHole($h_win, $i_x, $i_y, $i_sizew, $i_sizeh, $widtht, $heightt)

Local $outer_rgn, $inner_rgn, $combined_rgn

$outer_rgn = _WinAPI_CreateRectRgn(0, 0, $widtht, $heightt)
$inner_rgn = _WinAPI_CreateRectRgn($i_x, $i_y, $i_x + $i_sizew, $i_y + $i_sizeh)
$combined_rgn = _WinAPI_CreateRectRgn(0, 0, 0, 0)

_WinAPI_CombineRgn($combined_rgn, $outer_rgn, $inner_rgn, $RGN_DIFF)

_WinAPI_DeleteObject($outer_rgn)
_WinAPI_DeleteObject($inner_rgn)

_WinAPI_SetWindowRgn($h_win, $combined_rgn)

EndFunc

;Main Function to process the image when apply is pressed
Func ProcessImage()
   $dc = _WinAPI_GetDC ($GUI)
   $memDc = _WinAPI_CreateCompatibleDC ($dc)
   $bitmap = _WinAPI_CreateCompatibleBitmap ($dc, $width, $height)
   _WinAPI_SelectObject ($memDc, $bitmap)
   _WinAPI_BitBlt ($memDc, 0, 0, $width, $height, $dc, 0, 0, $SRCCOPY)
   $bits = DllStructCreate ("dword[" & ($width * $height) & "]")
   DllCall ("gdi32", "int", "GetBitmapBits", "ptr", $bitmap, "int", ($width * $height * 4), "ptr", DllStructGetPtr ($bits))
   GUICtrlDelete($imageBox)

   Dim $pixels[$width][$height]
   Dim $codes[$width][$height]
   Local $checkJustBlack = True
   For $j = 1 To 7
	  if $useColor[$j] And $checkJustBlack == True Then
		 $checkJustBlack = False
	  EndIf
   Next
   For $y = 0 To ($height - 1)
	  For $x = 0 To ($width - 1)
		 $index = ($y * $width) + $x
		 $color = DllStructGetData ($bits, 1, $index)
		 Local $colorArray[2] = [$color, 0]
		 $red = _ColorGetRed ($color)
		 $green = _ColorGetGreen ($color)
		 $blue = _ColorGetBlue ($color)
		 $shade = ($red + $green + $blue) / 3

		 if $checkJustBlack == False Then
			$colorArray = CompareColor ($red, $green, $blue)
			if ($colorArray[0] <> 0xa19565 And $colorArray[1] < 9) And ($shade > $thresholds[$colorArray[1]]) Then
			   $colorArray[0] = 0xB9B9B9
			   $codes[$x][$y] = 0
			   $pixels[$x][$y] = 0
			Else
			   $codes[$x][$y] = GetCode ($colorArray[0])
			   if ($foundColors[$codes[$x][$y] - 1] == false) And ($useColor[$codes[$x][$y] - 1] == true) then
				  $foundColors[$codes[$x][$y] - 1] = true
			   EndIf
			   $pixels[$x][$y] = 1
			EndIf
		 Else
			If ($shade > $thresholds[0]) Then
			   $colorArray[0] = 0xB9B9B9
			   $codes[$x][$y] = 0
			   $pixels[$x][$y] = 0
			Else
			   $colorArray[0] = 0
			   $foundColors[0] = true
			   $codes[$x][$y] = 1
			   $pixels[$x][$y] = 1
			EndIf
		 EndIf

		 DllStructSetData ($bits, 1, $colorArray[0], $index)
	  Next

	  DllCall ("gdi32", "int", "SetBitmapBits", "ptr", $bitmap, "int", ($width * $height * 4), "ptr", DllStructGetPtr ($bits))
	  _WinAPI_BitBlt ($dc, 0, 0, $width, $height, $memDc, 0, 0, $SRCCOPY)
	  GUICtrlSetData ($progress, ($y * 100) / $height)
   Next

   _WinAPI_ReleaseDC ($GUI, $dc)
   GUIRegisterMsg ($WM_PAINT, "OnPaint")
   TrayTip ("Shade Alteration Complete!", "Press F9 to lock position and draw. You can press F10 at anytime to exit. (F8 = Pause/Un-Pause After Draw Starts)", 20)
   GUISetState(@SW_ENABLE, $optGUI)

   HotKeySet ("{F9}", "Draw")
   HotKeySet ("{F10}", "Quit")
EndFunc

Func OnPaint ($hwndGUI, $msgID, $wParam, $lParam)
	Local $paintStruct = DllStructCreate ("hwnd hdc;int fErase;dword rcPaint[4];int fRestore;int fIncUpdate;byte rgbReserved[32]")

	$dc = DllCall ("user32", "hwnd", "BeginPaint", "hwnd", $hwndGUI, "ptr", DllStructGetPtr ($paintStruct))
	$dc = $dc[0]

	_WinAPI_BitBlt ($dc, 0, 0, $width, $height, $memDc, 0, 0, $SRCCOPY)

	DllCall ("user32", "hwnd", "EndPaint", "hwnd", $hwndGUI, "ptr", DllStructGetPtr ($paintStruct))
	Return $GUI_RUNDEFMSG
EndFunc

;Color comparrison function using RGB -> XYZ -> LAB (much more accurate than using basic RGB color comparisson)
Func CompareColor ($rVal, $gVal, $bVal)
   Local $ToLColors[9] = [0x000000, 0xc8b800, 0x007cc3, 0xe173df, 0xe1e1e1, 0x960000, 0x009600, 0x790098, 0xa19565];Black - yellow - blue - pink - white - Red - green - purple - background
   For $h = 0 To 7
	  if $useColor[$h] == False Then
		 $ToLColors[$h] = 0xa19565
	  EndIf
   Next
   Local $closest = 0x000000
   Local $diffMain = 200000000
   Local $diffCompare = 0
   Local $slot = 0
   Local $rHold
   Local $gHold
   Local $bHold
   Local $lab1[3] = [0, 0, 0]
   Local $lab2[3] = [0, 0, 0]
   For $i = 0 To 8
	  $rHold = _ColorGetRed ($ToLColors[$i])
	  $gHold = _ColorGetGreen ($ToLColors[$i])
	  $bHold = _ColorGetBlue ($ToLColors[$i])
	  $lab1 = rgb2lab ($rVal, $gVal, $bVal)
	  $lab2 = rgb2lab ($rHold, $gHold, $bHold)
	  $diffCompare = Sqrt((($lab2[0] - $lab1[0]) ^ 2) + (($lab2[1] - $lab1[1]) ^ 2) + (($lab2[2] - $lab1[2]) ^ 2))
	  If $diffCompare < $diffMain Then
		 $closest = $ToLColors[$i]
		 $diffMain = $diffCompare
		 $slot = $i
	  EndIf
   Next
   Local $returnVal[2] = [$closest, $slot]
   Return $returnVal
EndFunc

;Code function to know which color pixels to draw each time DrawArea is called
Func GetCode ($inputColor)
   Local $ToLColors[8] = [0x000000, 0xc8b800, 0x007cc3, 0xe173df, 0xe1e1e1, 0x960000, 0x009600, 0x790098];Black - yellow - blue - pink - white - Red - green - purple
   Local $CodeReturn = 9
   For $i = 0 To 7
	  If $inputColor == $ToLColors[$i] And $useColor[$i] Then
		 $CodeReturn = $i + 1
	  EndIf
   Next
   Return $CodeReturn
EndFunc

;RGB to Lab function
Func rgb2lab ($r, $g, $b)
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

   if $rr <= 0.04045 Then
	  $rr = $rr / 12.92 ;12.92 if worse
   Else
	  $rr = (($rr + 0.055) / 1.055) ^ 2.4
   EndIf

   if $gg <= 0.04045 Then
	  $gg = $gg / 12.92
   Else
	  $gg = (($gg + 0.055) / 1.055) ^ 2.4
   EndIf

   if $bb <= 0.04045 Then
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

   if $xr > $eps Then
	  $fx = $xr ^ (1/3)
   Else
	  $fx = ($k * $xr + 16.0) / 116.0
   EndIf

   if $yr > $eps Then
	  $fy = $yr ^ (1/3)
   Else
	  $fy = ($k * $yr + 16.0) / 116.0
   EndIf

   if $zr > $eps Then
	  $fz = $zr ^ (1/3)
   Else
	  $fz = ($k * $zr + 16.0) / 116.0
   EndIf

   $Ls = (116 * $fy) - 16
   $as = 500 * ($fx - $fy)
   $bs = 200 * ($fy - $fz)

   Local $labb[3] = [0, 0, 0]
   $labb[0] = int(2.55 * $Ls + 0.5)
   $labb[1] = int($as + 0.5)
   $labb[2] = int($bs + 0.5)
   return $labb
EndFunc

;Main Draw function to split the colors up into their own groups and draw the sections accordingly
Func Draw ()
   GUICtrlSetState($okBtn, $GUI_DISABLE)
   If (GUICtrlRead ($showRect) == $GUI_CHECKED) Then
	  GUICtrlSetState ($showRect, $GUI_UNCHECKED)
	  $drawFrame = False
	  GUIDelete ($hWin)
   EndIf
   GUICtrlSetState($showRect, $GUI_DISABLE)
   HotKeySet ("{F8}", "Pause")
   HotKeySet ("{F7}", "SkipNext")
   HotKeySet ("{F6}", "DrawNext")
   $drawing = 1
   $mouseCenter = MouseGetPos ()
   $x0 = $mouseCenter[0] - ($width / 2)
   $y0 = $mouseCenter[1] - ($height / 2)

   MouseMove ($x0, $y0)
   MouseMove ($x0 + $width, $y0)
   MouseMove ($x0 + $width, $y0 + $height)
   MouseMove ($x0, $y0 + $height)
   MouseMove ($x0, $y0)

   MsgBox($MB_ICONINFORMATION, "Important Information", "F8 = Pause / Unpause Draw" & @LF & @LF & "Please be sure to pause the drawing if the deathnote is force closed, or if you need to be able to move the mouse!")
   $stack = CreateStack (1000)
   For $i = 1 To 7
	  If $foundColors[$i] == true And $useColor[$i] == true then
		 $pixelHolder = True
		 Local $noteText = $selections[$i]
		 TrayTip("PRESS F7 TO SKIP COLOR!", "INFO: " & $noteText, 20)
		 While ($pixelHolder)
			sleep(100)
		 WEnd
		 If $skipColor == false Then
			For $y = 0 To ($height - 1)
			   For $x = 0 To ($width - 1)
				  If ($pixels[$x][$y] == 1 And $codes[$x][$y] == $i + 1) Then
					 MouseMove ($x + $x0, $y + $y0, $speed)
					 sleep(100)
					 MouseDown ("primary")
					 DrawArea ($stack, $x, $y, $x0, $y0, $codes[$x][$y])
					 MouseUp ("primary")
					 sleep(100)
				  EndIf
			   Next
			Next
		 EndIf
		 $skipColor = False
	  EndIf
   Next
   If $foundColors[0] == true then
	  $pixelHolder = True
	  Local $noteText = $selections[0]
	  TrayTip("PRESS F7 TO SKIP COLOR!", "INFO: " & $noteText, 20)
	  While ($pixelHolder)
		 sleep(100)
	  WEnd
	  If $skipColor == false Then
		 For $y = 0 To ($height - 1)
			For $x = 0 To ($width - 1)
			   If $pixels[$x][$y] == 1 And $codes[$x][$y] == 1 And $foundColors[0] == true Then
				  MouseMove ($x + $x0, $y + $y0, $speed)
				  sleep(100)
				  MouseDown ("primary")
				  DrawArea ($stack, $x, $y, $x0, $y0, $codes[$x][$y])
				  MouseUp ("primary")
				  sleep(100)
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
   HotKeySet ("{F8}")
   HotKeySet ("{F7}")
   HotKeySet ("{F6}")
   TrayTip("Status:", "Completed. Press F10 to Exit, F9 to Draw Again.", 20)
   GUICtrlSetState($showRect, $GUI_ENABLE)
   GUICtrlSetState($okBtn, $GUI_ENABLE)
EndFunc

;DrawArea function to group the pixels based on the pathing type, and move the mouse to those pixels depending on pattern selection
Func DrawArea (ByRef $stack, $x, $y, $x0, $y0, $currentCode)
   Local $path[8]
   Local $continue
   Local $delaycount = 0

   $path = MakePath ($pathString)

   While 1
	  if ($delaycount == $speedMouse) Then
		 sleep(10)
		 $delaycount = 0
	  else
		 $delaycount += 1
	  EndIf
	  MouseMove ($x + $x0, $y + $y0, $speed)
	  $pixels[$x][$y] = 2

	  If ($scramble) Then ScramblePath ($path)
	  If ($rotate > 0) Then RotatePath ($path, $rotate)

	  $continue = False
	  For $i = 0 To 7
		 Switch ($path[$i])
			Case 1
			   If (($x > 0) And ($y > 0)) Then
				  If ($pixels[$x - 1][$y - 1] == 1 And $codes[$x - 1][$y - 1] == $currentCode) Then
					 Push ($stack, $x, $y)
					 $x -= 1
					 $y -= 1
					 $continue = True
					 ExitLoop
				  EndIf
			   EndIf

			Case 2
			   If ($y > 0) Then
				  If ($pixels[$x][$y - 1] == 1 And $codes[$x][$y - 1] == $currentCode) Then
					 Push ($stack, $x, $y)
					 $y -= 1
					 $continue = True
					 ExitLoop
				  EndIf
			   EndIf

			Case 3
			   If (($x > 0) And ($y < 0)) Then
				  If ($pixels[$x + 1][$y - 1] == 1 And $codes[$x + 1][$y - 1] == $currentCode) Then
					 Push ($stack, $x, $y)
					 $x += 1
					 $y -= 1
					 $continue = True
					 ExitLoop
				  EndIf
			   EndIf

			Case 4
			   If ($x > 0) Then
				  If ($pixels[$x - 1][$y] == 1 And $codes[$x - 1][$y] == $currentCode) Then
					 Push ($stack, $x, $y)
					 $x -= 1
					 $continue = True
					 ExitLoop
				  EndIf
			   EndIf

			Case 5
			   If ($x < ($width - 1)) Then
				  If ($pixels[$x + 1][$y] == 1 And $codes[$x + 1][$y] == $currentCode) Then
					 Push ($stack, $x, $y)
					 $x += 1
					 $continue = True
					 ExitLoop
				  EndIf
			   EndIf

			Case 6
			   If (($x < 0) And ($y > 0)) Then
				  If ($pixels[$x - 1][$y + 1] == 1 And $codes[$x - 1][$y + 1] == $currentCode) Then
					 Push ($stack, $x, $y)
					 $x -= 1
					 $y += 1
					 $continue = True
					 ExitLoop
				  EndIf
			   EndIf

			Case 7
			   If ($y < ($height - 1)) Then
				  If ($pixels[$x][$y + 1] == 1 And $codes[$x][$y + 1] == $currentCode) Then
					 Push ($stack, $x, $y)
					 $y += 1
					 $continue = True
					 ExitLoop
				  EndIf
			   EndIf

			Case 8
			   If (($x < ($width - 1)) And ($y < ($height - 1))) Then
				  If ($pixels[$x + 1][$y + 1] == 1 And $codes[$x + 1][$y + 1] == $currentCode) Then
					 Push ($stack, $x, $y)
					 $x += 1
					 $y += 1
					 $continue = True
					 ExitLoop
				  EndIf
			   EndIf
		 EndSwitch
	  Next
	  If ($continue) Then ContinueLoop
	  If (Not Pop ($stack, $x, $y)) Then ExitLoop
   WEnd
EndFunc

;convert the string of numbers to a array of numbers
Func MakePath ($string)
   Return StringSplit ($string, "")
EndFunc

;randomize the path (for random pattern)
Func ScramblePath (ByRef $path)
   Local $table = "12345678"
   Local $newPath[8]

   For $i = 8 To 1 Step -1
	  $next = StringMid ($table, Random (1, $i, 1), 1)
	  $newPath[$i - 1] = Number ($next)
	  $table = StringReplace ($table, $next, "")
   Next
   $path = $newPath
EndFunc

;set the path to a circle pattern, outside -> inwards
Func RotatePath (Byref $path, $places)
   If ($places == 0) Then
	  Return $path
   Else
	  For $i = 1 To Abs ($places)
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
EndFunc

;create stack lol (self explainitory)
Func CreateStack ($size)
   Dim $stack[$size + 1][2]
   $stack[0][0] = 0
   $stack[0][1] = $size
   Return $stack
EndFunc

;push the stack
Func Push (ByRef $stack, $x, $y)
   $stack[0][0] += 1
   If ($stack[0][0] > $stack[0][1]) Then
	  $stack[0][1] += 1000
	  ReDim $stack[$stack[0][1] + 1][2]
   EndIf

   $stack[$stack[0][0]][0] = $x
   $stack[$stack[0][0]][1] = $y
EndFunc

;pop the stack
Func Pop (ByRef $stack, ByRef $x, ByRef $y)
   If ($stack[0][0] < 1) Then
	  Return False
   EndIf

   $x = $stack[$stack[0][0]][0]
   $y = $stack[$stack[0][0]][1]

   $stack[0][0] -= 1
   Return True
EndFunc

;function to start drawing the next color
Func DrawNext ()
   $pixelHolder = False
EndFunc

;function to prevent program from running if hotkeys cannot be bound
Func Nothing ()
EndFunc

;function to pause and unpause the drawing (example is in ToL if the night is about to end, pause, so when a log appears it doesnt keep drawing thinking the deathnote is still open)
Func Pause ()
   if ($drawing == 1) Then
	  $scriptPause = Not $scriptPause
	  if ($scriptPause) Then
		 $mouseloca = MouseGetPos()
		 MouseUp ("primary")
		 TrayTip("* Paused *", 'Script is "Paused", Press F8 to resume', 20)
	  else
		 MouseMove ($mouseloca[0], $mouseloca[1], $speed)
		 sleep(10)
		 MouseDown ("primary")
	  EndIf
	  While $scriptPause
		 Switch (GUIGetMsg ())
			Case $GUI_EVENT_CLOSE, $exitBtn
			   Exit
			Case $resetBtn
			   HotKeySet ("{F9}")
			   HotKeySet ("{F10}")
			   HotKeySet ("{F8}")
			   HotKeySet ("{F7}")
			   HotKeySet ("{F6}")
			   If @Compiled Then
				  ShellExecute(@ScriptFullPath)
			   Else
				  ShellExecute(@AutoItExe, @ScriptFullPath)
			   EndIf
			   Exit
		 EndSwitch
		 ;Sleep(100)
	  WEnd
	  TrayTip("Drawing Resumed!", "Script is now continuing to draw.", 20)
   else
	  TrayTip("ERROR", "Script must be drawing in order to pause.", 20)
   EndIf
EndFunc

;function to skip the next color if you realize you dont want to draw that color and dont want to reprocess the image with the color disabled
Func SkipNext ()
  $skipColor = True
  $pixelHolder = False
EndFunc

;i'm not even sure i need to bother commenting this one...
Func Quit ()
   MouseUp ("primary")
   Exit
EndFunc
