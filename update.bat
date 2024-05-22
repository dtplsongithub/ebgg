@echo off
if exist temp\ (
  echo Temp folder detected.
) else (
  echo Temp folder not detected. Creating one...
  mkdir temp
)
cd temp
if exist latestversion.zip (
  del latestversion.zip
)
echo Downloading latest version...
powershell -Command "Invoke-WebRequest https://github.com/dtplsongithub/ebgg/releases/latest/download/windows-amd64.zip -OutFile latestversion.zip"

cd..
dir
pause
xcopy "temp\windows-amd64\" ".\" /C /L
rd /S /Q "temp\"
echo Succesfully updated!
pause