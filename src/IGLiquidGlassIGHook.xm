// src/IGLiquidGlassIGHook.xm
//
// Theos + Logos tweak for Instagram (com.burbn.instagram)
// Forces Meta’s internal LiquidGlass UI gates ON.
//
// Implementation notes:
// - We use %hookf for C-level functions.
// - We do NOT declare externs for these functions.
// - We do NOT call the original implementations; we want hard overrides.
// - The symbols are resolved at runtime inside the Instagram process.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// 1) Global LiquidGlass experiment gate
%hookf(BOOL, METAIsLiquidGlassEnabled)
{
    return YES;
}

// 2) Custom LiquidGlass tab bar gate
%hookf(BOOL, IGIsCustomLiquidGlassTabBarEnabledForLauncherSet)
{
    return YES;
}

// 3) Tab bar style resolver
//
// The exact enum is proprietary, but from reverse-engineering we treat
// "2" as the LiquidGlass style. If Instagram changes the enum in future,
// this value can be adjusted without changing the hook pattern.
typedef NSInteger IGTabBarStyle;
static const IGTabBarStyle IGTabBarStyleLiquidGlass = 2;

%hookf(IGTabBarStyle, IGTabBarStyleForLauncherSet)
{
    return IGTabBarStyleLiquidGlass;
}

// No %ctor block is required here; Logos will generate the necessary
// initialization code to install these hooks when the tweak is loaded.
