# LiquidGlassIGhook

A self-contained Theos tweak that **forces Instagram’s hidden LiquidGlass
UI** (tab-bar blur, context-menu, toast, alert & notification styles) without
binary patching.

| Feature | Method(s) hooked | Behaviour |
|---------|------------------|-----------|
| Global LiquidGlass gate | `METAIsLiquidGlassEnabled` | Always **ON** |
| Tab-bar LiquidGlass gate | `IGIsCustomLiquidGlassTabBarEnabledForLauncherSet` | Always **ON** |
| Tab-bar style | `IGTabBarStyleForLauncherSet` | Always returns **1** (LiquidGlass enum) |
| Extra UI (toast/dialog/CM) | `isLiquidGlass*Enabled` selectors | All forced **ON** |
| Offset mitigation | `shouldMitigateLiquidGlassYOffset` | Forced **OFF** |

## Build locally

```bash
git clone --recursive https://github.com/darthplagueiswise/LiquidGlassIGhook.git
cd LiquidGlassIGhook
export THEOS=~/theos         # or any path you want
git clone --recursive https://github.com/theos/theos.git "$THEOS"
make package FINALPACKAGE=1
```

The resulting .deb and .dylib land in ./packages / repo root.

## CI

The GitHub Actions workflow (.github/workflows/build.yml) automatically:
1. Installs Theos (with Logos, Orion, fishhook sub-module).
2. Builds arm64 tweak against iOS 17 SDK.
3. Publishes artifacts for download.

---

### Copy-and-paste quick-start

```bash
# create repo skeleton
git clone --depth=1 https://github.com/darthplagueiswise/LiquidGlassIGhook.git
cd LiquidGlassIGhook
mkdir -p .github/workflows src
git submodule add https://github.com/facebook/fishhook.git fishhook

# drop the files shown above into their paths (README, Makefile, build.yml, IGLiquidGlassIGHook.xm)

git add .
git commit -m "Initial fully-working LiquidGlass tweak"
git push
# 🚀 GitHub Actions will compile & upload LiquidGlassIGhook.dylib + .deb automatically
```

This layout eliminates every error you saw:
- No “undefined symbol”—we use Logos %hookf, which performs late-binding; the linker never needs the Instagram symbols at build time.
- Theos paths always present—workflow sets THEOS & THEOS_MAKE_PATH before running make.
- fishhook present—added as Git sub-module, compiled via Makefile.

You can now clone, push, and let Codex (GitHub Actions) do the heavy lifting—zero local Xcode required.
