SET CURRENT_DIR=%~dp0
SET APK=%CURRENT_DIR%/build/quest/Ataito.apk
SET WINDOWS=%CURRENT_DIR%/build/windows/

echo Uploading to Itch...
butler -v push "%APK%" "samsarette/exo-gardener:android"
butler -v push "%WINDOWS%" "samsarette/exo-gardener:windows"

echo Done.
