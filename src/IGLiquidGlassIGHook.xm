// src/IGLiquidGlassIGHook.xm
//
// Theos / Logos tweak to force Instagram's internal LiquidGlass UI gates ON.
// Uses %hookf on private C functions.

#import <Foundation/Foundation.h>

#pragma mark - Tab bar style enum

typedef NSInteger IGTabBarStyle;
static const IGTabBarStyle IGTabBarStyleLiquidGlass = 2;

#pragma mark - Global LiquidGlass meta gate

%hookf(BOOL, METAIsLiquidGlassEnabled) {
    // Always report LiquidGlass as globally enabled.
    return YES;
}

#pragma mark - Custom LiquidGlass tab bar gate

%hookf(BOOL, IGIsCustomLiquidGlassTabBarEnabledForLauncherSet) {
    // Force the launcher tab bar to use the custom LiquidGlass style.
    return YES;
}

#pragma mark - Tab bar style resolver

%hookf(IGTabBarStyle, IGTabBarStyleForLauncherSet) {
    // Always return the LiquidGlass style.
    return IGTabBarStyleLiquidGlass;
}

#pragma mark - Optional future extensions

// If later you confirm more C-type gates (ex.: toasts, dialogs), you can
// add more %hookf in the same pattern:
//
// BOOL METAIsLiquidGlassToastEnabled(void);
// %hookf(BOOL, METAIsLiquidGlassToastEnabled) {
//     return YES;
// }
