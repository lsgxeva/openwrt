#
# Copyright 2023 Quectel Wireless Solutions Co.,Ltd
#

include $(TOPDIR)/rules.mk

PKG_NAME:=quectel-CM
PKG_VERSION:=1.6.4
PKG_RELEASE:=20220907

PKG_LICENSE:=MIT
PKG_LICENSE_FILES:=LICENSE

PKG_MAINTAINER:=Junxing Jiang <lsgx@live.com>

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

PKG_BUILD_PARALLEL:=1
PKG_BUILD_DEPENDS:=

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
  TITLE:=Quectel Connection Manager
  SECTION:=utils
  CATEGORY:=Network
  DEPENDS:=+libpthread
endef

define Package/$(PKG_NAME)/description
  Quectel Connection Manager tool for testing cellular connection 
endef

TARGET_CFLAGS += -I$(STAGING_DIR)/usr/include

ifeq ($(CONFIG_BIG_ENDIAN),y)
  TARGET_CFLAGS += -DHAVE_BIG_ENDIAN=1
endif

ifneq ($(CONFIG_USE_GLIBC),)
  TARGET_CFLAGS += -D_DEFAULT_SOURCE
else
  TARGET_CFLAGS += -D_GNU_SOURCE
endif

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
	$(CP) ./src/* $(PKG_BUILD_DIR)/
endef

define Build/Compile
	$(call Build/Compile/Default)
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/quectel-CM $(1)/usr/sbin/
endef

$(eval $(call BuildPackage,quectel-CM))
