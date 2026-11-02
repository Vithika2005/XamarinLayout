#!/usr/bin/env bash
# Runs the app as a native macOS (Mac Catalyst) window - the quickest way to see the result.
set -euo pipefail
cd "$(dirname "$0")/../LayoutsDemo"
dotnet build -f net10.0-maccatalyst -t:Run
