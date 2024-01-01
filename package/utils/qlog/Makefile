#
# Copyright 2023 Quectel Wireless Solutions Co.,Ltd
#

include $(TOPDIR)/rules.mk

PKG_NAME:=qlog
PKG_VERSION:=1.5.20
PKG_RELEASE:=20230808

PKG_LICENSE:=MIT
PKG_LICENSE_FILES:=LICENSE

PKG_MAINTAINER:=Junxing Jiang <lsgx@live.com>

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

PKG_BUILD_PARALLEL:=1
PKG_BUILD_DEPENDS:=

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
  TITLE:=Quectel Log tool
  SECTION:=utils
  CATEGORY:=Network
  DEPENDS:=+libpthread
endef

define Package/$(PKG_NAME)/description
  Quectel Log tool for capturing modem log
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
	$(INSTALL_DIR) $(1)/usr/sbin $(1)/etc/qlog
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/$(PKG_NAME) $(1)/usr/sbin/
	$(INSTALL_CONF) ./files/5GNR_LTE_CN_V11.cfg $(1)/etc/qlog/5GNR_LTE_CN_V11.cfg
	$(INSTALL_CONF) ./files/NR5GRegistration0608.cfg $(1)/etc/qlog/NR5GRegistration0608.cfg
	$(INSTALL_CONF) ./files/T1_LinuxData-OTA-DataService_V01.cfg $(1)/etc/qlog/T1_LinuxData-OTA-DataService_V01.cfg
	$(INSTALL_CONF) ./files/T2_RegServ-CotextAct_V01.cfg $(1)/etc/qlog/T2_RegServ-CotextAct_V01.cfg
	$(INSTALL_CONF) ./files/T3_SimpleData_V01.cfg $(1)/etc/qlog/T3_SimpleData_V01.cfg
	$(INSTALL_CONF) ./files/T4_Throughput_V01.cfg $(1)/etc/qlog/T4_Throughput_V01.cfg
	$(INSTALL_CONF) ./files/T5_COMMON_V01.cfg $(1)/etc/qlog/T5_COMMON_V01.cfg
	$(INSTALL_CONF) ./files/T6_FullMessage_V01.cfg $(1)/etc/qlog/T6_FullMessage_V01.cfg
	$(INSTALL_CONF) ./files/T7_V2X_ALL_V01.cfg $(1)/etc/qlog/T7_V2X_ALL_V01.cfg
	$(INSTALL_CONF) ./files/default.cfg $(1)/etc/qlog/default.cfg
	$(INSTALL_CONF) ./files/defaultNR5G1216.cfg $(1)/etc/qlog/defaultNR5G1216.cfg
endef

$(eval $(call BuildPackage,qlog))
