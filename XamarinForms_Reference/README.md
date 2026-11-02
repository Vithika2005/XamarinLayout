# Xamarin.Forms reference version (exactly as the lab sheet describes)

These files are the **literal Xamarin.Forms** implementation of Experiment 10:
a horizontal `StackLayout` header, `Grid` profile card, nested `StackLayout` stats row
(`CenterAndExpand`), `FlexLayout` tags and an `AbsoluteLayout` badge.

> **Heads-up:** Xamarin reached end of support on **1 May 2024** and Visual Studio for Mac was
> retired on **31 Aug 2024**. The Xamarin Android/iOS build tools do not run on a current
> Apple-silicon Mac. Use these files (a) in your lab report / submission, or (b) on a
> Windows PC with Visual Studio 2022 + the Xamarin workload, or an older Mac that still has it.
> To actually *run* the experiment on your M5 Mac, use the sibling `../LayoutsDemo` (.NET MAUI) project.

## How to use on a machine that still supports Xamarin
1. Visual Studio -> *Create a new project* -> **Mobile App (Xamarin.Forms)** -> name it `LayoutsDemoApp` -> **Blank** -> Android + iOS.
2. Replace the shared project's `MainPage.xaml` and `MainPage.xaml.cs` with the two files in this folder.
3. Add the images:
   - Android: copy `bell.png` and `profile.png` into `LayoutsDemoApp.Android/Resources/drawable/` (Build Action = **AndroidResource**).
   - iOS: copy them into `LayoutsDemoApp.iOS/Resources/` (Build Action = **BundleResource**).
4. Select the Android (or iOS) project as Startup Project, pick the emulator/simulator, press **Run**.

## What differs from the MAUI version
| Item | Xamarin.Forms (here) | .NET MAUI (`../LayoutsDemo`) |
|---|---|---|
| XML namespace | `http://xamarin.com/schemas/2014/forms` | `http://schemas.microsoft.com/dotnet/2021/maui` |
| Push bell to right edge | `HorizontalOptions="FillAndExpand"` on the title in a horizontal `StackLayout` | `Grid` with `*,Auto` columns (MAUI `StackLayout` ignores `*AndExpand`) |
| Even spacing of 3 stats | `CenterAndExpand` | `Grid` with `*,*,*` columns |
| Images | platform resource folders | one `Resources/Images` folder |
