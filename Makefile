THEOS_PACKAGE_DIR_NAME = debs
TARGET := iphone:clang:16.0:latest
ARCHS = arm64 arm64e
THEOS_SUBSTRATE_COMPAT = ios

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = InstagramLiquidGlassHook
$(TWEAK_NAME)_FILES = Tweak.xm
$(TWEAK_NAME)_CFLAGS = -fobjc-arc
$(TWEAK_NAME)_FRAMEWORKS = Foundation UIKit
$(TWEAK_NAME)_LIBRARIES = substrate
$(TWEAK_NAME)_DEPLOYMENT_TARGET = 16.0

# Set install_name to @executable_path/Frameworks for IPA injection
$(TWEAK_NAME)_INSTALL_NAME = @executable_path/Frameworks/InstagramLiquidGlassHook.dylib

include $(THEOS_MAKE_PATH)/tweak.mk

# Post-processing: Ensure install_name is set correctly after build
after-$(TWEAK_NAME)-stage::
	@echo "Setting install_name to @executable_path/Frameworks/InstagramLiquidGlassHook.dylib"
	install_name_tool -id "@executable_path/Frameworks/InstagramLiquidGlassHook.dylib" \
		$(THEOS_STAGING_DIR)/Library/MobileSubstrate/DynamicLibraries/$(TWEAK_NAME).dylib || true

