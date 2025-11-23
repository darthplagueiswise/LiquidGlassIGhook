# LiquidGlassIGhook

A small Theos tweak for Instagram (`com.burbn.instagram`) that forces Meta’s internal LiquidGlass UI gates ON, enabling the LiquidGlass tab bar style and related UI surfaces on modern iOS (including iOS 26).

The tweak is built as a standard MobileSubstrate tweak using Theos + Logos and is meant to be injected manually into an Instagram IPA (e.g. via Feather). This repository does **not** handle IPA patching or signing.

## Features

- Forces the global LiquidGlass experiment gate ON:
  - `METAIsLiquidGlassEnabled`
- Forces the custom LiquidGlass tab bar gate ON:
  - `IGIsCustomLiquidGlassTabBarEnabledForLauncherSet`
- Forces the tab bar style resolver to return the LiquidGlass style:
  - `IGTabBarStyleForLauncherSet`

All hooks are pure Logos `%hookf` C-function hooks.

## Structure

- `AGENTS.md` — Instructions for AI coding agents (Codex / Copilot Workspace).
- `Makefile` — Theos tweak Makefile.
- `control` — Debian package metadata.
- `LiquidGlassIGhook.plist` — Substrate filter; targets `com.burbn.instagram`.
- `src/IGLiquidGlassIGHook.xm` — Main tweak logic (Logos).
- `.github/workflows/build.yml` — GitHub Actions workflow (builds the tweak with Theos).

## Building (local Theos)

Prerequisites:

- Theos installed and configured.
- `THEOS` and `THEOS_MAKE_PATH` environment variables set.

Build:

```bash
make clean
make package FINALPACKAGE=1
```

The resulting .deb will be in packages/.

Building via GitHub Actions

This repository includes a GitHub Actions workflow (build) that:
	1.	Clones Theos into $HOME/theos.
	2.	Exports THEOS and THEOS_MAKE_PATH.
	3.	Runs make clean and make package FINALPACKAGE=1.
	4.	Uploads the .deb and .dylib as build artifacts.

Trigger a build by pushing to main or manually running the build workflow from the Actions tab.

---
