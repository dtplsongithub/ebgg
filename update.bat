: updater


@echo off
if exist temp\ (
  echo Temp folder detected.
  rd /S /Q "temp\"
  mkdir temp
) else (
  echo Temp folder not detected. Creating one...
  mkdir temp
)
cd temp
if exist latestversion.zip (
  del latestversion.zip
)
cls
echo.
echo What kind of ebgg version do you have?
echo.
echo 1) windows-amd64
echo 2) windows-amd64-openJDK-included
echo.
choice /C 12 /N
cls
if %ERRORLEVEL% EQU 2 (
  echo Downloading latest version...
  powershell Invoke-WebRequest https://github.com/dtplsongithub/ebgg/releases/latest/download/windows-amd64-openJDK-included.zip -OutFile   latestversion.zip
  echo %ERRORLEVEL%
  powershell Expand-Archive latestversion.zip -DestinationPath .\
  xcopy ".\windows-amd64-openJDK-included\" "..\" /L /Y /E
  echo %ERRORLEVEL%
) else if %ERRORLEVEL% EQU 1 (
  echo Downloading latest version...
  powershell Invoke-WebRequest https://github.com/dtplsongithub/ebgg/releases/latest/download/windows-amd64.zip -OutFile   latestversion.zip
  powershell Expand-Archive latestversion.zip -DestinationPath .\
  cd..
dir
  xcopy ".\temp\windows-amd64\" ".\" /L /Y /E
)
echo Succesfully updated! Press any key to exit...
pause>nul
cd..
rd /S /Q "temp\"