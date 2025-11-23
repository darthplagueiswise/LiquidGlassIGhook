// src/IGLiquidGlassIGHook.xm
//
// Theos / Logos tweak to force Instagram's internal LiquidGlass UI gates ON.
// We hook private C-level functions using %hookf. To avoid “undeclared identifier”
// errors, we declare the C prototypes *before* any Logos macros are used.

#pragma mark - Private C symbols (prototypes)

// These are *not* declared in any public header, so we declare them ourselves.
// Signatures baseadas no que você viu no Ghidra: sem argumentos, retornos simples.

typedef NSInteger IGTabBarStyle;

BOOL METAIsLiquidGlassEnabled(void);
BOOL IGIsCustomLiquidGlassTabBarEnabledForLauncherSet(void);
IGTabBarStyle IGTabBarStyleForLauncherSet(void);

#pragma mark - Standard imports

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#pragma mark - Global LiquidGlass meta gate

// BOOL METAIsLiquidGlassEnabled(void);
%hookf(BOOL, METAIsLiquidGlassEnabled) {
    // Always report LiquidGlass as globally enabled.
    return YES;
}

#pragma mark - Custom LiquidGlass tab bar gate

// BOOL IGIsCustomLiquidGlassTabBarEnabledForLauncherSet(void);
%hookf(BOOL, IGIsCustomLiquidGlassTabBarEnabledForLauncherSet) {
    // Force the launcher tab bar to use the custom LiquidGlass style.
    return YES;
}

#pragma mark - Tab bar style resolver

// Enum-like return; constant chosen via reverse engineering.
static const IGTabBarStyle IGTabBarStyleLiquidGlass = 2;

// IGTabBarStyle IGTabBarStyleForLauncherSet(void);
%hookf(IGTabBarStyle, IGTabBarStyleForLauncherSet) {
    // Always return the LiquidGlass style.
    return IGTabBarStyleLiquidGlass;
}

#pragma mark - Optional future C gates
// If later you confirm additional C gates (toasts, dialogs, etc.), you can add:
// BOOL METAIsLiquidGlassToastEnabled(void);
// %hookf(BOOL, METAIsLiquidGlassToastEnabled) { return YES; }
