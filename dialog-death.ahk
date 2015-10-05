#NoEnv

ini := A_AppData . "\Dialog Death\dialog-death.ini"
default_action := "{Enter}"
ProgramName := "Dialog Death"
if (A_IsCompiled) {
  icon_on := A_ScriptFullPath
  icon_on_index := 2
  icon_off := A_ScriptFullPath
  icon_off_index := 3
} else {
  icon_on := "..\share\dialog-death\dialog-death.ico"
  icon_on_index := 0
  icon_off := "..\share\dialog-death\dialog-death-off.ico"
  icon_off_index := 0
}

reload_settings()
{
  global

  i := 1
  loop {
    iniread titles[%i%][title], %ini%, Titles, %i%
    if (titles[%i%][title] = "ERROR")
      break

    iniread titles[%i%][matchmode], %ini%, Titles, MatchMode%i%, 3
    if (    titles[%i%][matchmode] <> 1
        and titles[%i%][matchmode] <> 2
        and titles[%i%][matchmode] <> 3
        and titles[%i%][matchmode] <> RegEx) {
      title := titles[%i%][title]
      matchmode := titles[%i%][matchmode]
      msgbox 16, Illegal MatchMode - %ProgramName%, Illegal MatchMode %matchmode% for "%title%".`n`nMatchMode must be one of`n`n1: Match prefix`n2: Match substring`n3: Match exactly`nRegEx: Match as a regular expression`n`nPlease change the MatchMode to one of`nthese values and restart %ProgramName%.
      exit 1
    }

    j := 1
    loop {
      section := titles[%i%][title]

      iniread text, %ini%, %section%, %j%
      if (text = "ERROR")
        break

      titles[%i%][texts][%j%][text] := RegExReplace(RegExReplace(text, "%LF%", Chr(10)), "%CR%", Chr(13))
      if (ErrorLevel < 0)
        break
      titles := titles[%i%][texts][%j%][text]

      iniread titles[%i%][texts][%j%][action], %ini%, %section%, Action%j%, %default_action%
      iniread titles[%i%][texts][%j%][always], %ini%, %section%, Always%j%, 0

      j := j + 1
    }
    titles[%i%][texts][count] := j - 1

    i := i + 1
  }
  titles[count] := i - 1
}

menu tray, icon, %icon_on%, %icon_on_index%, 1
menu tray, tip, %ProgramName%
menu tray, nostandard
menu tray, add, &Reload Settings, ReloadSettings
menu tray, add
menu tray, add, &Pause, Pause
menu tray, add, E&xit, Exit
menu tray, default, &Pause

Paused := 0

reload_settings()

loop {
  sleep 400
  loop %titles[count]% {
    mode := titles[%a_index%][matchmode]
    settitlematchmode %mode%
    if winactive(titles[%a_index%][title]) {
      i := a_index
      texts_count := titles[%i%][texts][count]
      loop %texts_count% {
        if winactive(titles[%i%][title], titles[%i%][texts][%a_index%][text]) {
          action := titles[%i%][texts][%a_index%][action]
          send %action%
          break
        }
      }
    }
  }
}

ReloadSettings:
reload_settings()
traytip Settings Reloaded, %ProgramName%'s settings have been reloaded., , 17
settimer RemoveTrayTip, 4000
return

RemoveTrayTip:
settimer RemoveTrayTip, off
traytip
return

Pause:
if (Paused) {
  menu tray, rename, Un&pause, &Pause
  menu tray, default, &Pause
  menu tray, icon, %icon_on%, %icon_on_index%, 1
} else {
  menu tray, rename, &Pause, Un&pause
  menu tray, default, Un&pause
  menu tray, icon, %icon_off%, %icon_off_index%, 1
}
Paused := !Paused
pause
return

Exit:
exit
return
