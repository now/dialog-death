SetCompressor /SOLID lzma

Name "Dialog Death"
OutFile "installer/Setup.exe"
InstallDir "$PROGRAMFILES\Dialog Death"
InstallDirRegKey HKLM "Software\Dialog Death" "Installation Directory"
RequestExecutionLevel admin
ShowInstDetails show
XPStyle on
AllowSkipFiles off
VIAddVersionKey "ProductName" "Dialog Death"
VIAddVersionKey "FileDescription" "Remove pesky dialogs by sending key sequences to dismiss them"
VIAddVersionKey "CompanyName" "bitwi.se"
VIAddVersionKey "FileVersion" "1.0.0"
VIAddVersionKey "ProductVersion" "1.0.0"
VIAddVersionKey "LegalCopyright" "Nikolai Weibull 2008"
VIProductVersion "1.0.0.0"
BrandingText " "

Page directory
Page instfiles

UninstPage uninstConfirm
UninstPage instfiles

Var /GLOBAL Name

Section "-Install"
  StrCpy $Name "Dialog Death"

  SetOutPath $INSTDIR

  File bin\dialog-death.exe

  IfFileExists dialog-death.ini skip_ini
    File installer\dialog-death.ini

skip_ini:

  CreateShortCut "$SMSTARTUP\$Name.lnk" "$INSTDIR\dialog-death.exe"

  ; Factor this out into a function
  WriteRegStr HKLM "Software\$Name" "Installation Directory" $INSTDIR

  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\$Name" "DisplayName" "$Name"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\$Name" "UninstallString" '"$INSTDIR\uninstall.exe"'
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\$Name" "NoModify" 1
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\$Name" "NoRepair" 1

  WriteUninstaller "uninstall.exe"

  Exec '"$INSTDIR\dialog-death.exe"'
SectionEnd

Section "Uninstall"
  StrCpy $Name "Dialog Death"

  Delete "$SMSTARTUP\$Name.lnk"

  Processes::KillProcess "dialog-death"

  Sleep 500

  Delete "$INSTDIR\dialog-death.exe"

  Delete $INSTDIR\uninstall.exe

  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\$Name"
  DeleteRegKey HKLM "Software\$Name"
SectionEnd
