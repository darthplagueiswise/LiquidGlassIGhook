TARGET := iphone:clang:latest
ARCHS  := arm64

# The process we want to inject into
INSTALL_TARGET_PROCESSES = Instagram

# Theos paths are provided by CI via THEOS and THEOS_MAKE_PATH.
# Locally, you can set:
#   export THEOS=~/theos
#   export THEOS_MAKE_PATH=$THEOS/makefiles

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = LiquidGlassIGhook

$(TWEAK_NAME)_FILES      = $(wildcard src/*.xm)
$(TWEAK_NAME)_FRAMEWORKS = UIKit Foundation
$(TWEAK_NAME)_CFLAGS     = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 Instagram || true"
