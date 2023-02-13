#!/bin/bash
CURRENT_DIR=$(dirname "$(readlink -f "$0")")
APK="$CURRENT_DIR/build/quest/ExoGardener.apk"
WINDOWS="$CURRENT_DIR/build/windows/"
LINUX="$CURRENT_DIR/build/linux/"

echo Uploading to Itch...
butler -v push "$APK" "samsarette/exo-gardener:android"
butler -v push "$WINDOWS" "samsarette/exo-gardener:windows"
butler -v push "$LINUX" "samsarette/exo-gardener:linux"

echo Done.
