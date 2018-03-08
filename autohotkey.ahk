#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

;Get title of active window
!^T::
{
	DetectHiddenWindows, On
	WinGetTitle, Title, A
	MsgBox, The active window is "%Title%".
	return
}

;--------------------------------- Spotify ----------------------------------

;"CTRL + ALT + SPACE for pause/play
!^Space::Media_Play_Pause

;"CTRL + ALT + Page down" for next song
!^PgDn::Media_Next

;"CTRL + ALT + Page up" for previous song
!^PgUp::Media_Prev


; -------------------------------- Volume------------------------------------

;"CTRL + ALT + NUMPAD8" for Volume up
!^Numpad8::
{
	Send {Volume_Up}
	return
}

;"CTRL + ALT + NUMPAD2" for Volume up
!^Numpad2::
{
	Send {Volume_Down}
	return
}
;"CTRL + ALT + NUMPAD5" for Mute
!^Numpad5::
{
	Send {Volume_Mute}
	return
}
; -------------------------------- Autocorrect--------------------------------
; Ctrl+Alt+c autocorrect selected text
^!c::
clipback := ClipboardAll
clipboard=
Send ^c
ClipWait, 0
UrlDownloadToFile % "https://www.google.com/search?q=" . clipboard, temp
FileRead, contents, temp
FileDelete temp
if (RegExMatch(contents, "(Visar resultat för|Menade du:)</span>.*?>(.*?)</a>", match)) {
   StringReplace, clipboard, match2, <b><i>,, All
   StringReplace, clipboard, clipboard, </i></b>,, All
}
Send ^v
Sleep 500
clipboard := clipback
return

;---------------------------------Open wiki-----------------------------------
!^w::

ClipSaved := ClipboardAll   ; Save the entire clipboard
Clipboard =                 ; Clear the clipboard (useful for when there is no highlighted text)
Send ^c                     ; Copy the highlighted text to the clipboard
ClipWait 1                  ; Wait up to 1 second for the clipboard to contain data
if ErrorLevel               ; If there is no data in the clipboard after 1 second, exit
{
   MsgBox, The attempt to copy text onto the clipboard failed.
   return
}
SearchString := Clipboard   ; Assign the clipboard content to the variable
Clipboard := ClipSaved      ; Restore the original clipboard
ClipSaved =                 ; Free the memory in case the clipboard was very large


SearchString := "https://en.wikipedia.org/w/index.php?search=" . SearchString
StringReplace, searchString, searchString, %A_Space%, +, All


Run chrome.exe -new-tab %SearchString%
return

;---------------------------------Google search selected text--------------------------
!^g::

ClipSaved := ClipboardAll   ; Save the entire clipboard
Clipboard =                 ; Clear the clipboard (useful for when there is no highlighted text)
Send ^c                     ; Copy the highlighted text to the clipboard
ClipWait 1                  ; Wait up to 1 second for the clipboard to contain data
if ErrorLevel               ; If there is no data in the clipboard after 1 second, exit
{
   MsgBox, The attempt to copy text onto the clipboard failed.
   return
}
SearchString := Clipboard   ; Assign the clipboard content to the variable
Clipboard := ClipSaved      ; Restore the original clipboard
ClipSaved =                 ; Free the memory in case the clipboard was very large


SearchString := "http://www.google.com/search?&q=" . SearchString
StringReplace, searchString, searchString, %A_Space%, +, All

Run chrome.exe -new-tab %SearchString%
return


;---------------------------------Copy to cmd---------------------------------
#IfWinActive ahk_class ConsoleWindowClass
^V::
SendInput {Raw}%clipboard%
return
#IfWinActive

;-------------------------------Ctrl + backspace everywhere--------------------
#IfWinActive ahk_class CabinetWClass ; File Explorer
    ^Backspace::
#IfWinActive ahk_class Notepad
    ^Backspace::
    Send ^+{Left}{Backspace}