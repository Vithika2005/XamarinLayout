---
title: "Experiment No. 10 — Develop Xamarin Applications Using Layouts and Views"
---

# EXPERIMENT No. 10
## Develop Xamarin Applications Using Layouts and Views

| | |
|---|---|
| Name | ______________________ |
| Roll No. / Class | ______________________ |
| Date | ______________________ |
| Platform used | macOS (Apple M5), .NET MAUI (successor of Xamarin.Forms), Mac Catalyst / iOS Simulator / Android Emulator |

---

## 1. Aim
To install the cross-platform mobile development environment and develop an application that demonstrates the
Xamarin.Forms layout containers — **StackLayout, Grid, AbsoluteLayout, FlexLayout and ScrollView** — together with
core views (**Label, Image, Button, Frame, BoxView**) arranged inside them, by building a single dashboard-style screen.

## 2. Objectives
1. Install and configure the development environment with the mobile workload.
2. Verify the environment.
3. Understand the default solution / project structure.
4. Understand the difference between a *view* and a *layout* and how layouts nest.
5. Design one screen combining several layout types.
6. Run and test it on an emulator / simulator / device.

## 3. Software and hardware used

| Requirement | Used |
|---|---|
| Hardware | MacBook with Apple M5 chip, ≥16 GB RAM, ≥25 GB free disk |
| OS | macOS (latest) |
| SDK | .NET SDK 10 (arm64) with the **maui** workload |
| IDE / editor | Visual Studio Code + C# Dev Kit + .NET MAUI extension |
| iOS tools | Xcode + iOS Simulator |
| Android tools | Android Studio, Android SDK, arm64-v8a emulator image, JDK 17 |
| Language | C# and XAML |

> **Note on tooling.** The lab sheet specifies Visual Studio (for Mac) with the Xamarin workload. Xamarin support ended
> on 1 May 2024 and Visual Studio for Mac was retired on 31 Aug 2024; neither runs on a current Apple-silicon Mac.
> The experiment was therefore carried out with **.NET MAUI**, the official successor, whose layout containers and views
> are the same classes with the same names. A literal Xamarin.Forms version of the page is supplied in
> `XamarinForms_Reference/`.

---

## 4. Theory

### 4.1 Xamarin.Forms and .NET MAUI
Xamarin.Forms is a cross-platform UI toolkit that lets a developer describe a user interface once (in XAML or C#) and
render it with **native controls** on Android and iOS. .NET MAUI (Multi-platform App UI) is its evolution: a single-project
model with one code base targeting Android, iOS, macOS (Mac Catalyst) and Windows.

### 4.2 Views and layouts
Every visual element derives from the base class **`View`**.
* A **simple view** (Label, Image, Button, Entry, BoxView) displays content or accepts input.
* A **layout** is a special view whose job is to **position and size its children** according to a rule.
* Layouts can contain other layouts, so a screen is a **tree** (visual tree). Over-nesting costs rendering time, so the right layout should be chosen for each task.

| Term | Meaning |
|---|---|
| View | Any visual element on a page |
| Layout | A view that arranges child views by a rule |
| Child | A view placed inside a layout |

### 4.3 Layout containers used in this experiment

| Layout | Rule | Used here for |
|---|---|---|
| **ScrollView** | Holds exactly one child and scrolls it when larger than the screen | Whole page |
| **StackLayout** | Children one after another, vertical (default) or horizontal | Page backbone, name/role text, each statistic |
| **Grid** | Rows × columns; `Grid.Row`, `Grid.Column`, spans; sizes: absolute, `Auto`, star (`*`) | Profile card (80 + *), header, stats row |
| **AbsoluteLayout** | Child placed at exact x, y, width, height; children may overlap | Bell icon with overlapping notification badge |
| **FlexLayout** | CSS-flexbox-like; `Wrap="Wrap"` lets items flow to the next line | Tag chips |
| RelativeLayout | Constraints relative to parent / siblings (legacy) | not used |

### 4.4 Views used

| View | Purpose in the screen |
|---|---|
| Label | Title, name, role, numbers, captions, tags |
| Image | Bell icon, profile photo |
| Button | "View Full Profile" (raises `Clicked`) |
| Frame | Card (profile) and rounded chips (tags) |
| BoxView | Red circular badge, thin divider line |

### 4.5 Sizing and alignment
* `HorizontalOptions` / `VerticalOptions` (Start, Center, End, Fill) align a view inside the space its parent gives it.
* In **Xamarin.Forms**, the `…AndExpand` variants (e.g. `FillAndExpand`, `CenterAndExpand`) make a child claim spare space inside a `StackLayout`.
* In **.NET MAUI**, `StackLayout` ignores the expand flags (they are obsolete); equivalent behaviour is obtained with a `Grid` using star columns. This is the only structural difference between the two versions of the page.
* `WidthRequest` / `HeightRequest` request a size; `Padding` is space inside a layout; `Margin` is space outside a view; `Spacing` is the gap between stacked children.

### 4.6 Project structure (default template)

| Item | Purpose |
|---|---|
| Shared project (`LayoutsDemo`) | XAML pages and logic shared by all platforms |
| `App.xaml` / `App.xaml.cs` | Application resources and start page |
| `MainPage.xaml` / `.cs` | First page and its code-behind |
| `MauiProgram.cs` | App bootstrap (builder) — MAUI only |
| `Platforms/Android`, `Platforms/iOS`, `Platforms/MacCatalyst` | Platform entry points, manifests, plists |
| `Resources/Images`, `Resources/AppIcon` | Shared images and icon |

---

## 5. Procedure (what we did)

### 5.1 Environment installation (macOS, M5)
1. Installed **Xcode** from the App Store, opened it once, accepted the licence, ran `sudo xcodebuild -runFirstLaunch`.
2. Installed **Homebrew**, then the **.NET SDK (arm64)** and **JDK 17** with `bash scripts/setup-mac.sh`.
3. Installed the workload: `sudo dotnet workload install maui`.
4. Installed **Android Studio**, created an arm64 Pixel virtual device (Android Virtual Device Manager).
5. Installed **VS Code** with the *C# Dev Kit* and *.NET MAUI* extensions.

### 5.2 Verification
| Check | Command | Expected |
|---|---|---|
| .NET present | `dotnet --version` | 10.x |
| Workload present | `dotnet workload list` | `maui`, `android`, `ios`, `maccatalyst` |
| iOS simulators | `xcrun simctl list devices available` | iPhone entries |
| Android | `adb --version`, `emulator -list-avds` | version string, AVD name |

### 5.3 Project creation
Equivalent of *Create new project → Mobile App → Blank → Android + iOS* in the lab sheet:
`dotnet new maui -n LayoutsDemo` (the supplied project is the result of this template with the dashboard added).

### 5.4 Designing the screen (nesting plan)

```
ScrollView
└── StackLayout (vertical)
    ├── Header ........ Grid [*, Auto]  →  Label + AbsoluteLayout(Image, BoxView, Label)
    ├── Profile ....... Frame → Grid [80, *] → Image + StackLayout(Label, Label)
    ├── Statistics .... Grid [*, *, *] → 3 × StackLayout(Label number, Label caption)
    ├── Divider ....... BoxView (1 px high)
    ├── Tag list ...... FlexLayout (Wrap) → 11 × Frame(Label)
    └── Button ........ "View Full Profile"
```

| Step | Action | Layout concept shown |
|---|---|---|
| 1 | `ScrollView` as outermost element with one child, a vertical `StackLayout` (Spacing 20, Padding 20) | Scrolling; a single-child container |
| 2 | Header: title `Label` left; `AbsoluteLayout` 48×48 right with bell `Image` at (0,8,40,40) and red round `BoxView` badge at (28,0,18,18) plus a "3" `Label` | Absolute positioning and intentional overlap |
| 3 | `Frame` card containing a 2-column `Grid` (80 fixed, `*`); profile `Image` in column 0, `StackLayout` of two `Label`s in column 1 | Grid sizing; layout nested in a Grid cell |
| 4 | Stats row: three vertical `StackLayout`s (bold number, small caption), evenly spaced | Nested StackLayouts, even distribution |
| 5 | `FlexLayout Wrap="Wrap"` with 11 chip `Frame`s each holding a `Label` | Wrapping flow layout |
| 6 | Full-width `Button` with `Clicked` handler showing an alert | Event handling |
| 7 | Reviewed nesting: ScrollView has one child; Grid columns match children; badge coordinates relative to icon; FlexLayout Wrap on | Design checks |

### 5.5 Running
* **Mac window:** `bash scripts/run-maccatalyst.sh`
* **iOS Simulator:** `bash scripts/run-ios.sh <UDID>`
* **Android Emulator:** `emulator -avd <name>` then `bash scripts/run-android.sh`

Then the window / emulator was resized and rotated and the page scrolled.

---

## 6. Observations
*Complete the "Observed" column from your own run, and attach screenshots from `docs/screenshots/`.*

| # | Element | Expected behaviour | Observed (✔ / note) |
|---|---|---|---|
| 1 | App launch | Window/emulator shows "Dashboard" page without errors | |
| 2 | Header | Title at left; bell icon at right edge | |
| 3 | AbsoluteLayout | Red "3" badge overlaps the bell's top-right corner; stays there at all sizes | |
| 4 | Frame + Grid | Round photo in narrow column, name and role in wide column; card has rounded corners and shadow | |
| 5 | Stats row | 128 · 4.2K · 310 evenly spaced across the width | |
| 6 | BoxView divider | Thin grey line below the stats | |
| 7 | FlexLayout | 11 tags flow onto several lines; line breaks change when width changes | |
| 8 | Rotation / resize | Tags re-wrap; no content cut off | |
| 9 | ScrollView | In short window/landscape the page scrolls; Button reachable | |
| 10 | Button | Tap shows "Opening the full profile of Alex Morgan..." alert | |

**General observations**
* A layout only positions children; it draws nothing itself — the visible card look comes from `Frame`, the dot from `BoxView`.
* `AbsoluteLayout` is the only container here that lets views overlap, which is what makes the badge possible.
* `FlexLayout` with `Wrap` adapts to width automatically, whereas a plain `StackLayout` would overflow the screen edge.
* `Grid` star sizing gives proportional, resolution-independent columns.
* In MAUI, `StackLayout` does not honour `FillAndExpand`/`CenterAndExpand`; a `Grid` with `*` columns was used for the header and statistics row to obtain the same appearance. In Xamarin.Forms (`XamarinForms_Reference/MainPage.xaml`) the expand flags work and those two rows are horizontal `StackLayout`s exactly as in the lab sheet.
* Deep nesting adds layout passes; the page keeps the tree shallow (max depth ≈ 5).

**Difficulties met / deviations**
* Xamarin/Visual Studio for Mac are discontinued → performed on .NET MAUI + VS Code.
* iOS cannot be built on Windows; macOS + Xcode is required, which is satisfied here.

---

## 7. Result
A cross-platform dashboard screen using **ScrollView, StackLayout, Grid, AbsoluteLayout and FlexLayout** with
**Label, Image, Button, Frame and BoxView** was designed, built and executed on macOS / iOS Simulator / Android Emulator.
The page scrolled, the Grid-based profile card aligned correctly, the FlexLayout tags wrapped when the width changed, and the
AbsoluteLayout badge overlapped the notification icon as intended.

## 8. Conclusion
The experiment covered the whole workflow of composing a screen from several layouts: preparing the toolchain, verifying
it, understanding the solution structure, distinguishing views from layouts and nesting `StackLayout`, `Grid`,
`AbsoluteLayout`, `FlexLayout` and `ScrollView` into one coherent interface. Each layout has a different job —
stacking, tabular alignment, exact/overlapping placement, wrapping flow and scrolling — and choosing the right one
(and keeping nesting shallow) yields UIs that adapt to different screen sizes and orientations. It also showed that
Xamarin.Forms skills transfer directly to .NET MAUI, with small API differences such as the removal of `*AndExpand`
in `StackLayout`.

---

## 9. Viva questions (with short answers)
1. **View vs layout?** A view is any visual element; a layout is a view that arranges children.
2. **Why does ScrollView take only one child?** It scrolls a single content element; put a layout inside to host many.
3. **When use Grid over StackLayout?** For rows/columns aligned in two dimensions or proportional sizing.
4. **What does `*` mean in a Grid?** Share of the remaining space; `2*` takes twice as much as `*`.
5. **Which layout allows overlap?** AbsoluteLayout (also Grid when two children share a cell).
6. **What does `Wrap="Wrap"` do in FlexLayout?** Moves items to the next line when the row is full.
7. **Frame vs BoxView?** Frame is a container with border/shadow/corners; BoxView is a coloured rectangle.
8. **HorizontalOptions values?** Start, Center, End, Fill (+ AndExpand variants in Xamarin.Forms).
9. **Why avoid deep nesting?** Each layout adds measure/arrange passes → slower rendering.
10. **Xamarin.Forms vs MAUI?** MAUI is the successor: single project, .NET 6+, more platforms; Xamarin is out of support.

## 10. References
* Microsoft Learn — .NET MAUI layouts: https://learn.microsoft.com/dotnet/maui/user-interface/layouts/
* Microsoft Learn — Xamarin.Forms layouts: https://learn.microsoft.com/xamarin/xamarin-forms/user-interface/layouts/
* Xamarin support policy: https://dotnet.microsoft.com/platform/support/policy/xamarin
* Migrating Xamarin.Forms to .NET MAUI: https://learn.microsoft.com/dotnet/maui/migration/
