TWEAK_NAME = DedupeVariants
DedupeVariants_OBJCC_FILES = Tweak.xm
DedupeVariants_CFLAGS = -F$(SYSROOT)/System/Library/CoreServices

TARGET := iphone:7.1:5.0
ARCHS := armv6 arm64

include theos/makefiles/common.mk
include theos/makefiles/tweak.mk

after-install::
	install.exec "killall -9 backboardd"

distclean: clean
	- rm -f $(THEOS_PROJECT_DIR)/$(APP_ID)*.deb
	- rm -f $(THEOS_PROJECT_DIR)/.theos/packages/*
