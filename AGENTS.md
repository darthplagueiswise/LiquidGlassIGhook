# AGENTS.md — LiquidGlassIGhook

You are an AI coding agent (GitHub Copilot Workspace / Codex) working on the repository `LiquidGlassIGhook`.

Your job is to maintain a **single Theos tweak** that builds a `.dylib` / `.deb` to force Instagram’s internal LiquidGlass UI feature gates ON. The tweak will later be injected into an Instagram IPA outside this repo; do NOT try to handle IPA patching or signing here.

## Project overview

- Type: Theos MobileSubstrate tweak
- Target bundle: `com.burbn.instagram`
- Architecture: `arm64` only
- Purpose:
  - Override Instagram C-level gates for LiquidGlass:
    - `METAIsLiquidGlassEnabled`
    - `IGIsCustomLiquidGlassTabBarEnabledForLauncherSet`
    - `IGTabBarStyleForLauncherSet`
  - Force these to return “enabled” / LiquidGlass style.

## Important commands (CI is the source of truth)

The canonical build runs in GitHub Actions, not in your own environment.

- Build & package (used by CI):

  ```bash
  make clean
  make package FINALPACKAGE=1

•Theos location in CI:
•Cloned at $HOME/theos with git clone --recursive https://github.com/theos/theos.git $HOME/theos
•Environment in CI:
•THEOS=$HOME/theos
•THEOS_MAKE_PATH=$THEOS/makefiles

You may run make inside the Workspace only as a synthetic check; failures there do not necessarily reflect CI.

Repository structure

This repo should contain at minimum:
•AGENTS.md — this file (agent instructions).
•README.md — short human-oriented overview and basic usage.
•Makefile — Theos tweak Makefile, no custom build system.
•control — Debian package metadata for the tweak.
•LiquidGlassIGhook.plist — Substrate filter, restricts to com.burbn.instagram.
•src/IGLiquidGlassIGHook.xm — main Logos source file, implementing the hooks.
•.github/workflows/build.yml — CI pipeline using Theos to build the tweak.

No Theos submodule should live inside this repo. Theos is cloned dynamically by CI.

Makefile requirements
•Use Theos tweak style:

TARGET := iphone:clang:latest
ARCHS  := arm64

INSTALL_TARGET_PROCESSES = Instagram

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = LiquidGlassIGhook

$(TWEAK_NAME)_FILES      = $(wildcard src/*.xm)
$(TWEAK_NAME)_FRAMEWORKS = UIKit Foundation
$(TWEAK_NAME)_CFLAGS     = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk


•Do not hardcode absolute Theos paths in the Makefile; rely on THEOS and THEOS_MAKE_PATH from the environment (CI sets them).

Tweak implementation expectations
•Use Logos C-function hooks (%hookf) only.
•Override the LiquidGlass gates completely, without calling the original implementations.

%hookf(BOOL, METAIsLiquidGlassEnabled) {
    return YES;
}

%hookf(BOOL, IGIsCustomLiquidGlassTabBarEnabledForLauncherSet) {
    return YES;
}

typedef NSInteger IGTabBarStyle;
static const IGTabBarStyle IGTabBarStyleLiquidGlass = 2; // chosen by RE

%hookf(IGTabBarStyle, IGTabBarStyleForLauncherSet) {
    return IGTabBarStyleLiquidGlass;
}


•Do NOT:
•Add extern declarations for these functions.
•Use fishhook, MSHookFunction, MSFindSymbol, or manual Mach-O parsing, unless explicitly requested.
•Call the original implementation from these hooks. For now, we want a hard override (always-on).

GitHub Actions workflow
•Must run on macos-latest (or macos-15).
•Must:
•git clone --recursive https://github.com/theos/theos.git $HOME/theos
•Export:
•THEOS=$HOME/theos
•THEOS_MAKE_PATH=$THEOS/makefiles
•Run:

make clean
make package FINALPACKAGE=1


•Upload artifacts:
•packages/*.deb
•The built .dylib from .theos/obj/**/LiquidGlassIGhook.dylib (use globs).

Boundaries
•Do NOT:
•Add additional apps or tweak targets.
•Add IPA manipulation, signing, or injection logic.
•Touch secrets, tokens, or CI credentials.
•Focus solely on:
•Keeping the tweak buildable.
•Maintaining the Makefile, workflow, and Logos hook implementation.
•Updating the code when Instagram or Theos changes symbol names or build requirements.

How to behave
•Prefer small, focused changes.
•Before edits, read Makefile, .github/workflows/build.yml, and src/IGLiquidGlassIGHook.xm.
•After edits, ensure:
•make package FINALPACKAGE=1 is a valid command for CI.
•CI has everything it needs to produce .deb and .dylib artifacts.

---
