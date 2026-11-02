# Experiment 10 – Layouts and Views (Xamarin.Forms → .NET MAUI)

A single dashboard screen that combines **ScrollView, StackLayout, Grid, AbsoluteLayout and FlexLayout**
with **Label, Image, Button, Frame and BoxView** views.

| | |
|---|---|
| Aim | Build a cross-platform mobile screen that demonstrates the Xamarin.Forms layout containers and core views |
| Runs on | macOS (Apple silicon), iOS Simulator, Android Emulator |
| Language | C# 13 / XAML |
| Full write-up | [`docs/EXPERIMENT_REPORT.md`](docs/EXPERIMENT_REPORT.md) (also `.docx`) |

---

## ⚠️ Important: why this repo has both "MAUI" and "Xamarin" folders

Xamarin reached **end of support on 1 May 2024** and **Visual Studio for Mac was retired on 31 Aug 2024**.
The Xamarin build tools cannot be installed on a current Apple-silicon (M-series) Mac, so the lab as written
(Visual Studio for Mac + Xamarin workload) can no longer be followed on your machine.

The replacement is **.NET MAUI**, Microsoft's direct successor to Xamarin.Forms. Its layouts and views have the
same names and the same XAML (only the XML namespace changes), so the experiment's learning outcomes are identical.

* `LayoutsDemo/` – **runnable** .NET MAUI project (use this on your M5 Mac).
* `XamarinForms_Reference/` – the literal Xamarin.Forms `MainPage.xaml` from the lab sheet (for your report, or for a Windows PC with VS 2022 that still has the Xamarin workload).

> The MAUI project was written carefully against the standard MAUI template but could not be compiled in the
> environment where it was generated (no .NET SDK there). If the build reports an error on your Mac, see
> [Troubleshooting](#troubleshooting) – fixes are usually a one-liner.

---

## Repository layout

```
Exp10_Xamarin_Layouts_Views/
├── README.md                     ← you are here
├── .gitignore
├── docs/
│   ├── EXPERIMENT_REPORT.md      ← Aim, Theory, Procedure, Observation, Result, Conclusion
│   ├── EXPERIMENT_REPORT.docx    ← same, for printing / submission
│   ├── GIT_GUIDE.md              ← step-by-step: put this on GitHub
│   └── screenshots/              ← put your own screenshots here
├── scripts/
│   ├── setup-mac.sh              ← one-time installs
│   ├── run-maccatalyst.sh        ← run as a Mac window (easiest)
│   ├── run-ios.sh                ← run in iOS Simulator
│   └── run-android.sh            ← run in Android Emulator
├── LayoutsDemo/                  ← .NET MAUI project (runnable)
│   ├── LayoutsDemo.csproj
│   ├── App.xaml / App.xaml.cs
│   ├── MainPage.xaml / .cs       ← THE dashboard screen (all layouts live here)
│   ├── MauiProgram.cs
│   ├── Resources/{Images,AppIcon}
│   └── Platforms/{Android,iOS,MacCatalyst}
└── XamarinForms_Reference/       ← original-style Xamarin.Forms version
```

---

## Layout tree of the screen

```
ContentPage
└── ScrollView                               (1 child only)
    └── StackLayout (vertical)               backbone
        ├── Grid [*, Auto]                   header
        │   ├── Label "Dashboard"
        │   └── AbsoluteLayout               bell + badge overlap
        │       ├── Image bell.png
        │       ├── BoxView (red circle)
        │       └── Label "3"
        ├── Frame                            card
        │   └── Grid [80, *]
        │       ├── Image profile.png
        │       └── StackLayout → Label name, Label role
        ├── Grid [*, *, *]                   stats
        │   └── 3 × StackLayout → Label number, Label caption
        ├── BoxView                          divider
        ├── Label "Interests"
        ├── FlexLayout (Wrap)                11 × Frame → Label  (tag chips)
        └── Button "View Full Profile"
```

---

## Part A – One-time setup on a Mac (M5 / Apple silicon)

Estimated time: 45–90 min (mostly downloads). Disk: ~25 GB free recommended.

### A1. Install Xcode (needed for iOS and Mac Catalyst)
1. Mac App Store → install **Xcode** (large download).
2. Open Xcode once, accept the licence, let it install components.
3. In Terminal:
   ```bash
   sudo xcode-select -s /Applications/Xcode.app/Contents/Developer
   sudo xcodebuild -runFirstLaunch
   xcrun simctl list devices available | head      # you should see iPhone simulators
   ```

### A2. Install Homebrew, .NET SDK, JDK and the MAUI workload
```bash
# Homebrew (skip if `brew --version` already works)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

cd Exp10_Xamarin_Layouts_Views
bash scripts/setup-mac.sh
```
This installs the **arm64 .NET SDK**, **Temurin JDK 17** and runs `sudo dotnet workload install maui`.
Verify:
```bash
dotnet --version            # 10.x
dotnet workload list        # should list "maui" (and android / ios / maccatalyst)
```
> If your SDK major version is not 10, open `LayoutsDemo/LayoutsDemo.csproj` and the three `scripts/run-*.sh`
> files and replace `net10.0` with your version (e.g. `net9.0`).

### A3. Android SDK + emulator (only if you want to test on Android)
1. Install **Android Studio** (https://developer.android.com/studio → *Apple Silicon* build).
2. First launch → *Standard* setup (installs SDK + platform-tools + emulator).
3. *More Actions → Virtual Device Manager → Create Device* → e.g. **Pixel 8** → system image **API 34/35, arm64-v8a** (must be arm64 on an M-series Mac) → Finish.
4. Add to `~/.zshrc`:
   ```bash
   export ANDROID_HOME="$HOME/Library/Android/sdk"
   export JAVA_HOME="$(/usr/libexec/java_home -v 17)"
   export PATH="$PATH:$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator"
   ```
   then `source ~/.zshrc`.
5. Check: `adb --version` and `emulator -list-avds`.

### A4. Editor – VS Code (replaces Visual Studio for Mac)
1. Install VS Code → Extensions: **C# Dev Kit** and **.NET MAUI** (both by Microsoft).
2. `File → Open Folder…` → choose `Exp10_Xamarin_Layouts_Views/LayoutsDemo`.

---

## Part B – Run it

### Option 1 – As a Mac app window (fastest, no emulator needed)
```bash
bash scripts/run-maccatalyst.sh
# equivalent to:
cd LayoutsDemo && dotnet build -f net10.0-maccatalyst -t:Run
```
First build takes a few minutes (restoring packages). A window "Layouts & Views Dashboard" opens.
Drag the window narrower/wider to watch the FlexLayout tags re-wrap.

### Option 2 – iOS Simulator
```bash
bash scripts/run-ios.sh              # lists simulators, you paste a UDID
# or:  bash scripts/run-ios.sh <UDID>
```
Rotate in Simulator: **⌘←** / **⌘→**.

### Option 3 – Android Emulator
```bash
emulator -avd <YOUR_AVD_NAME> &      # wait until the home screen appears
bash scripts/run-android.sh
```
Rotate with the emulator side toolbar's rotate buttons.

### Option 4 – From VS Code
Command palette (**⇧⌘P**) → *.NET MAUI: Pick Target Framework / Device*, then press **F5**.

---

## Part C – Verify (what to check, matches lab steps 40–42)

- [ ] Header "Dashboard" on left; bell on right with **red "3" badge overlapping its top-right corner**
- [ ] Profile card: round photo in the narrow column, name + role in the wide column
- [ ] Stats row: 128 / 4.2K / 310 evenly spaced
- [ ] Tags wrap onto several lines; rotate/resize → they re-wrap
- [ ] Page scrolls to reveal the **View Full Profile** button when the window is short (landscape)
- [ ] Tapping the button shows an alert
- [ ] Badge stays on the bell at every size

Save screenshots into `docs/screenshots/` (Simulator: ⌘S; Mac: ⇧⌘4 then Space, click the window).

---

## Troubleshooting

| Symptom | Fix |
|---|---|
| `No .NET SDK found` / wrong version | `brew install --cask dotnet-sdk`; check `dotnet --version`; adjust `net10.0` if needed |
| `Workload ... not installed` | `sudo dotnet workload install maui` then `dotnet workload update` |
| "This version of .NET for iOS requires Xcode X.Y" | Install the Xcode version named in the message (Mac App Store / developer.apple.com/download), then `sudo xcode-select -s /Applications/Xcode.app/Contents/Developer`; or `sudo dotnet workload update` |
| `Could not find Android SDK` | `export ANDROID_HOME=$HOME/Library/Android/sdk` and re-run (script also passes it) |
| `JAVA_HOME` / `javac` errors | `export JAVA_HOME="$(/usr/libexec/java_home -v 17)"` |
| Emulator very slow / won't boot | Use an **arm64-v8a** image, not x86 |
| Code-signing error on iOS/Catalyst | Xcode → Settings → Accounts → add your (free) Apple ID; Simulator and Mac Catalyst debug need no paid account |
| Build is stale / strange errors | `dotnet clean` then delete `bin/` and `obj/` folders and rebuild |
| `Frame` / `DisplayAlert` warnings | Harmless; they are silenced in the csproj via `NoWarn` |

---

## Documentation
Full lab write-up (Aim, Theory, Procedure, Observation, Result, Conclusion, viva Q&A):
[`docs/EXPERIMENT_REPORT.md`](docs/EXPERIMENT_REPORT.md) · Word version: `docs/EXPERIMENT_REPORT.docx`

## Put this on GitHub
See [`docs/GIT_GUIDE.md`](docs/GIT_GUIDE.md). Short version:
```bash
cd Exp10_Xamarin_Layouts_Views
git init -b main
git add .
git commit -m "Experiment 10: layouts and views dashboard"
gh repo create xamarin-layouts-views --public --source=. --push
```

## License
For educational use. Add a `LICENSE` file (e.g. MIT) if you want others to reuse it.
