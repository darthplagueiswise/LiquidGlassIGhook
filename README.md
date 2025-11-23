# LiquidGlassIGhook (Theos tweak)

A simple Theos MobileSubstrate tweak that forces Instagram's internal
LiquidGlass UI gates ON.

## What it does

Hooks the following C-level symbols inside Instagram's shared frameworks:

- `BOOL METAIsLiquidGlassEnabled(void);`
- `BOOL IGIsCustomLiquidGlassTabBarEnabledForLauncherSet(void);`
- `IGTabBarStyle IGTabBarStyleForLauncherSet(void);`

and forces them to return:

- `METAIsLiquidGlassEnabled` → `YES`
- `IGIsCustomLiquidGlassTabBarEnabledForLauncherSet` → `YES`
- `IGTabBarStyleForLauncherSet` → a constant "LiquidGlass" style (2)

This makes the tab bar use the LiquidGlass style regardless of server-side
flags.

## Build

The project uses Theos and Logos. In CI the toolchain is installed at `$HOME/theos`.

```bash
make clean
make package FINALPACKAGE=1
```

The build produces:
- `packages/*.deb`
- `.theos/obj/**/LiquidGlassIGhook.dylib`

Inject the resulting dylib into Instagram as you normally would for a tweak.
