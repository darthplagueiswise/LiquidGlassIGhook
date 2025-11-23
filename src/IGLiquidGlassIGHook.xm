#import <substrate.h>
#import <objc/runtime.h>
#include "fishhook.h"

#pragma mark - C-level gates (safe Logos %hookf)

%hookf(BOOL, METAIsLiquidGlassEnabled)                { return YES; }
%hookf(BOOL, IGIsCustomLiquidGlassTabBarEnabledForLauncherSet) { return YES; }
%hookf(int,  IGTabBarStyleForLauncherSet)             { return 1; }    // 1 → LiquidGlass

#pragma mark - Runtime Objective-C flag overrides

static BOOL _lg_yes(id self, SEL _cmd) { return YES; }
static BOOL _lg_no (id self, SEL _cmd) { return NO; }

static void lgHookSelector(const char *name, BOOL yes) {
    SEL sel = sel_getUid(name);
    if (!sel) return;

    int num = objc_getClassList(NULL, 0);
    Class *classes = (Class *)malloc(sizeof(Class)*num);
    num = objc_getClassList(classes, num);

    IMP imp = (IMP)(yes ? _lg_yes : _lg_no);

    for (int i = 0; i < num; i++) {
        Class c = classes[i];
        if (class_respondsToSelector(c, sel)) {
            Method m = class_getInstanceMethod(c, sel);
            method_setImplementation(m, imp);
        }
        Class meta = object_getClass(c);
        if (meta && class_respondsToSelector(meta, sel)) {
            Method m = class_getClassMethod(meta, sel);
            method_setImplementation(m, imp);
        }
    }
    free(classes);
}

__attribute__((constructor))
static void lgInit(void) {
    // 1. Extra LiquidGlass booleans → YES
    const char *yesSels[] = {
        "isLiquidGlassContextMenuEnabled",
        "isLiquidGlassInAppNotificationEnabled",
        "isLiquidGlassToastEnabled",
        "isLiquidGlassToastPeekEnabled",
        "isLiquidGlassAlertDialogEnabled"
    };
    for (unsigned i = 0; i < sizeof(yesSels)/sizeof(*yesSels); i++)
        lgHookSelector(yesSels[i], YES);

    // 2. YOffset mitigation → NO (optional)
    lgHookSelector("shouldMitigateLiquidGlassYOffset", NO);
}
