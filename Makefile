export ARCHS = arm64
export TARGET = iphone:clang:latest:17.0
export THEOS_PACKAGE_SCHEME = rootless

INSTALL_TARGET_PROCESSES = Instagram

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = LiquidGlassIGhook
$(TWEAK_NAME)_FILES = $(wildcard src/*.xm)
$(TWEAK_NAME)_FRAMEWORKS = UIKit Foundation
$(TWEAK_NAME)_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
