#!/usr/bin/env bash
# Runs the app in an iOS Simulator.
# Usage:  bash scripts/run-ios.sh            (lists simulators, then asks for a UDID)
#         bash scripts/run-ios.sh <UDID>
set -euo pipefail
cd "$(dirname "$0")/../LayoutsDemo"

UDID="${1:-}"
if [ -z "$UDID" ]; then
  echo "Available simulators:"
  xcrun simctl list devices available | grep -E "iPhone|iPad" || true
  echo
  read -r -p "Paste the UDID of the simulator to use: " UDID
fi

xcrun simctl boot "$UDID" 2>/dev/null || true   # ok if already booted
open -a Simulator
dotnet build -f net10.0-ios -t:Run -p:_DeviceName=:v2:udid="$UDID"
