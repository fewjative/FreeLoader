ARCHS = armv7 arm64
include theos/makefiles/common.mk

BUNDLE_NAME = FreeLoaderSettings
FreeLoaderSettings_FILES = FreeLoaderSettings.mm
FreeLoaderSettings_INSTALL_PATH = /Library/PreferenceBundles
FreeLoaderSettings_FRAMEWORKS = UIKit Social
FreeLoaderSettings_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/Application\ Support/FreeLoader$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/FreeLoaderSettings.plist$(ECHO_END)

include $(THEOS_MAKE_PATH)/aggregate.mk
