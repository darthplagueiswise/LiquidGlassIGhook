export ARCHS = arm64
export TARGET = iphone:clang:latest:17.0
export THEOS_PACKAGE_SCHEME = rootless

INSTALL_TARGET_PROCESSES = Instagram

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = LiquidGlassIGhook
LiquidGlassIGhook_FILES = src/IGLiquidGlassIGHook.xm \
                          fishhook/fishhook.c
LiquidGlassIGhook_LDFLAGS += -undefined dynamic_lookup
LiquidGlassIGhook_FRAMEWORKS = UIKit Foundation
LiquidGlassIGhook_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
