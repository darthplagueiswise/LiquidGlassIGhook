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

\t•\tTheos location in CI:
\t•\tCloned at $HOME/theos with git clone --recursive https://github.com/theos/theos.git $HOME/theos
\t•\tEnvironment in CI:
\t•\tTHEOS=$HOME/theos
\t•\tTHEOS_MAKE_PATH=$THEOS/makefiles

You may run make inside the Workspace only as a synthetic check; failures there do not necessarily reflect CI.

Repository structure

This repo should contain at minimum:
\t•\tAGENTS.md — this file (agent instructions).
\t•\tREADME.md — short human-oriented overview and basic usage.
\t•\tMakefile — Theos tweak Makefile, no custom build system.
\t•\tcontrol — Debian package metadata for the tweak.
\t•\tLiquidGlassIGhook.plist — Substrate filter, restricts to com.burbn.instagram.
\t•\tsrc/IGLiquidGlassIGHook.xm — main Logos source file, implementing the hooks.
\t•\t.github/workflows/build.yml — CI pipeline using Theos to build the tweak.

No Theos submodule should live inside this repo. Theos is cloned dynamically by CI.

Makefile requirements
\t•\tUse Theos tweak style:

TARGET := iphone:clang:latest
ARCHS  := arm64

INSTALL_TARGET_PROCESSES = Instagram

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = LiquidGlassIGhook

$(TWEAK_NAME)_FILES      = $(wildcard src/*.xm)
$(TWEAK_NAME)_FRAMEWORKS = UIKit Foundation
$(TWEAK_NAME)_CFLAGS     = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk


\t•\tDo not hardcode absolute Theos paths in the Makefile; rely on THEOS and THEOS_MAKE_PATH from the environment (CI sets them).

Tweak implementation expectations
\t•\tUse Logos C-function hooks (%hookf) only.
\t•\tOverride the LiquidGlass gates completely, without calling the original implementations.

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


\t•\tDo NOT:
\t•\tAdd extern declarations for these functions.
\t•\tUse fishhook, MSHookFunction, MSFindSymbol, or manual Mach-O parsing, unless explicitly requested.
\t•\tCall the original implementation from these hooks. For now, we want a hard override (always-on).

GitHub Actions workflow
\t•\tMust run on macos-latest (or macos-15).
\t•\tMust:
\t•\tgit clone --recursive https://github.com/theos/theos.git $HOME/theos
\t•\tExport:
\t•\tTHEOS=$HOME/theos
\t•\tTHEOS_MAKE_PATH=$THEOS/makefiles
\t•\tRun:

make clean
make package FINALPACKAGE=1


\t•\tUpload artifacts:
\t•\tpackages/*.deb
\t•\tThe built .dylib from .theos/obj/**/LiquidGlassIGhook.dylib (use globs).

Boundaries
\t•\tDo NOT:
\t•\tAdd additional apps or tweak targets.
\t•\tAdd IPA manipulation, signing, or injection logic.
\t•\tTouch secrets, tokens, or CI credentials.
\t•\tFocus solely on:
\t•\tKeeping the tweak buildable.
\t•\tMaintaining the Makefile, workflow, and Logos hook implementation.
\t•\tUpdating the code when Instagram or Theos changes symbol names or build requirements.

How to behave
\t•\tPrefer small, focused changes.
\t•\tBefore edits, read Makefile, .github/workflows/build.yml, and src/IGLiquidGlassIGHook.xm.
\t•\tAfter edits, ensure:
\t•\tmake package FINALPACKAGE=1 is a valid command for CI.
\t•\tCI has everything it needs to produce .deb and .dylib artifacts.

---
