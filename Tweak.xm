#import <substrate.h>
#import <Foundation/Foundation.h>

// Standard ARM64 stub: mov w0, #1; ret (hex: 20 00 80 52 C0 03 5F D6)
#define STUB_BYTES "\x20\x00\x80\x52\xc0\x03\x5f\xd6"

// Helper macro to safely hook a symbol
#define SAFE_HOOK(symbolName, hookFunc, origPtr, counter) \
    do { \
        void *symbol = MSFindSymbol(NULL, symbolName); \
        if (symbol) { \
            MSHookFunction(symbol, (void *)hookFunc, (void **)&origPtr); \
            counter++; \
            NSLog(@"[LiquidGlass] Hooked %s", symbolName); \
        } else { \
            NSLog(@"[LiquidGlass] WARNING: Symbol %s not found", symbolName); \
        } \
    } while(0)

// Function pointers for original implementations (if needed for logging)
static BOOL (*orig_METAIsLiquidGlassEnabled)(void);
static BOOL (*orig_IGIsCustomLiquidGlassTabBarEnabledForLauncherSet)(void);
static BOOL (*orig_IGTabBarDynamicSizingEnabled)(void);
static BOOL (*orig_IGTabBarIsFloatingStyle)(void);
static BOOL (*orig_IGTabBarShouldEnableBlurDebugListener)(void);
static BOOL (*orig_IGDSAlwaysDarkBlurBackground)(void);
static int (*orig_IGTabBarStyleForLauncherSet)(void);

// Hook functions with inline assembly stubs
BOOL hook_METAIsLiquidGlassEnabled(void) {
    NSLog(@"[LiquidGlass] Hooked _METAIsLiquidGlassEnabled: returning YES");
    __asm__ volatile("mov w0, #1; ret");
}

BOOL hook_IGIsCustomLiquidGlassTabBarEnabledForLauncherSet(void) {
    NSLog(@"[LiquidGlass] Hooked _IGIsCustomLiquidGlassTabBarEnabledForLauncherSet: returning YES");
    __asm__ volatile("mov w0, #1; ret");
}

BOOL hook_IGTabBarDynamicSizingEnabled(void) {
    NSLog(@"[LiquidGlass] Hooked _IGTabBarDynamicSizingEnabled: returning YES");
    __asm__ volatile("mov w0, #1; ret");
}

BOOL hook_IGTabBarIsFloatingStyle(void) {
    NSLog(@"[LiquidGlass] Hooked _IGTabBarIsFloatingStyle: returning YES");
    __asm__ volatile("mov w0, #1; ret");
}

BOOL hook_IGTabBarShouldEnableBlurDebugListener(void) {
    NSLog(@"[LiquidGlass] Hooked _IGTabBarShouldEnableBlurDebugListener: returning YES");
    __asm__ volatile("mov w0, #1; ret");
}

BOOL hook_IGDSAlwaysDarkBlurBackground(void) {
    NSLog(@"[LiquidGlass] Hooked _IGDSAlwaysDarkBlurBackground: returning YES");
    __asm__ volatile("mov w0, #1; ret");
}

int hook_IGTabBarStyleForLauncherSet(void) {
    NSLog(@"[LiquidGlass] Hooked _IGTabBarStyleForLauncherSet: returning 1");
    __asm__ volatile("mov w0, #1; ret");
}

%ctor {
    @autoreleasepool {
        int hooksApplied = 0;
        
        // Hook each function using MSHookFunction (Substrate)
        SAFE_HOOK("_METAIsLiquidGlassEnabled", hook_METAIsLiquidGlassEnabled, orig_METAIsLiquidGlassEnabled, hooksApplied);
        SAFE_HOOK("_IGIsCustomLiquidGlassTabBarEnabledForLauncherSet", hook_IGIsCustomLiquidGlassTabBarEnabledForLauncherSet, orig_IGIsCustomLiquidGlassTabBarEnabledForLauncherSet, hooksApplied);
        SAFE_HOOK("_IGTabBarDynamicSizingEnabled", hook_IGTabBarDynamicSizingEnabled, orig_IGTabBarDynamicSizingEnabled, hooksApplied);
        SAFE_HOOK("_IGTabBarIsFloatingStyle", hook_IGTabBarIsFloatingStyle, orig_IGTabBarIsFloatingStyle, hooksApplied);
        SAFE_HOOK("_IGTabBarShouldEnableBlurDebugListener", hook_IGTabBarShouldEnableBlurDebugListener, orig_IGTabBarShouldEnableBlurDebugListener, hooksApplied);
        SAFE_HOOK("_IGDSAlwaysDarkBlurBackground", hook_IGDSAlwaysDarkBlurBackground, orig_IGDSAlwaysDarkBlurBackground, hooksApplied);
        SAFE_HOOK("_IGTabBarStyleForLauncherSet", hook_IGTabBarStyleForLauncherSet, orig_IGTabBarStyleForLauncherSet, hooksApplied);
        
        NSLog(@"[LiquidGlass] Hooks applied: %d/7. LiquidGlass features enabled.", hooksApplied);
    }
}

/*
V2 Patch Details (for reference):
- Stub: ARM64 "mov w0, #1; ret" (hex: 20 00 80 52 C0 03 5F D6)
- _METAIsLiquidGlassEnabled @ 0xA59064 (orig: fd7bbfa9fd030091)
- _IGIsCustomLiquidGlassTabBarEnabledForLauncherSet @ 0x409904 (orig: fd7bbfa9fd030091)
- _IGTabBarDynamicSizingEnabled @ 0x74A96C (orig: 43668bd24301a0f2)
- _IGTabBarIsFloatingStyle @ 0x409904 (already stubbed, enforced)
- _IGTabBarShouldEnableBlurDebugListener @ 0xAE7368 (orig: f44fbea9fd7b01a9)
- _IGDSAlwaysDarkBlurBackground @ 0xADFD18 (orig: f44fbea9fd7b01a9) [NEW in V2]
- _IGTabBarStyleForLauncherSet @ 0x40271C (orig: f44fbea9fd7b01a9) [returns 1 as int]
Safe for BOOL/enum only; avoids structs/colors.
*/

