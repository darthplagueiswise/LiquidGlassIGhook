// src/IGLiquidGlassIGHook.xm
//
// Theos / Logos tweak to force Instagram's internal LiquidGlass UI gates ON.
// Uses %hookf on private C functions. We declare prototypes explicitly so
// clang knows these symbols exist at link/load time.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#pragma mark - Private C symbols (prototypes)

// These functions live in Instagram's shared frameworks (ex.: FBSharedFramework).
// They do NOT exist in public headers, so we declare them here to satisfy the compiler.
// Assumindo pela engenharia reversa que todas são funções sem argumentos (void).

typedef NSInteger IGTabBarStyle;

BOOL METAIsLiquidGlassEnabled(void);
BOOL IGIsCustomLiquidGlassTabBarEnabledForLauncherSet(void);
IGTabBarStyle IGTabBarStyleForLauncherSet(void);

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

// The original function likely returns an enum representing tab bar style.
static const IGTabBarStyle IGTabBarStyleLiquidGlass = 2;

// IGTabBarStyle IGTabBarStyleForLauncherSet(void);
%hookf(IGTabBarStyle, IGTabBarStyleForLauncherSet) {
    // Always return the LiquidGlass style.
    return IGTabBarStyleLiquidGlass;
}

#pragma mark - Optional future extensions

// If later you confirmar mais gates C-type (ex.: toasts, dialogs), você pode
// adicionar mais %hookf nesta mesma pegada:
//
// BOOL METAIsLiquidGlassToastEnabled(void);
// %hookf(BOOL, METAIsLiquidGlassToastEnabled) {
//     return YES;
// }
