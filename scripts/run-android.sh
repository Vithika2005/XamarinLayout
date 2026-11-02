#!/usr/bin/env bash
# Runs the app on an already-running Android emulator (or a USB device).
# Start the emulator first, e.g.:  ~/Library/Android/sdk/emulator/emulator -avd <AVD_NAME>
set -euo pipefail

export ANDROID_HOME="${ANDROID_HOME:-$HOME/Library/Android/sdk}"
export PATH="$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator:$PATH"

echo "Connected devices:"
adb devices
cd "$(dirname "$0")/../LayoutsDemo"
dotnet build -f net10.0-android -t:Run -p:AndroidSdkDirectory="$ANDROID_HOME"
