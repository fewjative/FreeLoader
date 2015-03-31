ARCHS = armv7 arm64
include theos/makefiles/common.mk

TWEAK_NAME = FreeLoader
FreeLoader_FILES = Tweak.xm
FreeLoader_FRAMEWORKS = UIKit
FreeLoader_CFLAGS = -Wno-error
export GO_EASY_ON_ME := 1
include $(THEOS_MAKE_PATH)/tweak.mk

SUBPROJECTS += FreeLoaderSettings
include $(THEOS_MAKE_PATH)/aggregate.mk

before-stage::
	find . -name ".DS_STORE" -delete
after-install::
	install.exec "killall -9 backboardd"
