#!/usr/bin/env bash
# One-time environment setup for macOS on Apple silicon (M-series).
# Run from the repo root:   bash scripts/setup-mac.sh
set -euo pipefail

echo "==> 1/5 Checking Homebrew"
if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew not found. Install it from https://brew.sh and re-run this script."
  exit 1
fi

echo "==> 2/5 Checking Xcode command-line tools / Xcode"
if ! xcode-select -p >/dev/null 2>&1; then
  xcode-select --install || true
  echo "Finish the Command Line Tools install popup, then re-run this script."
  exit 1
fi
if [ ! -d /Applications/Xcode.app ]; then
  echo "!! Full Xcode is NOT installed. Install it from the Mac App Store (needed for iOS / Mac Catalyst)."
  echo "   After installing: open Xcode once, accept the licence, then run:  sudo xcodebuild -runFirstLaunch"
fi

echo "==> 3/5 Installing .NET SDK (arm64) and JDK 17 (for Android)"
brew install --cask dotnet-sdk || brew upgrade --cask dotnet-sdk || true
brew install --cask temurin@17 || true

echo "==> 4/5 Installing the .NET MAUI workload"
sudo dotnet workload install maui

echo "==> 5/5 Summary"
dotnet --version
dotnet workload list
echo
echo "Done. Next: Android SDK/emulator (see README, section 'Android') and then:  bash scripts/run-maccatalyst.sh"
