TWEAK_NAME      = LiquidGlassIGhook
LiquidGlassIGhook_FILES = src/IGLiquidGlassIGHook.xm \
                          fishhook/fishhook.c
LiquidGlassIGhook_LDFLAGS += -undefined dynamic_lookup
ARCHS            = arm64
TARGET           = iphone:clang:17.0
INSTALL_TARGET_PROCESSES = Instagram

include $(THEOS_MAKE_PATH)/tweak.mk
