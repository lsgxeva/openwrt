#
# Copyright (C) 2006-2016 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=checknet
PKG_VERSION:=1.0.5
PKG_RELEASE:=20220315
PKG_LICENSE:=GPLv3
PKG_LICENSE_FILES:=LICENSE

include $(INCLUDE_DIR)/package.mk

define Package/checknet
  SECTION:=utils
  CATEGORY:=Utilities
  TITLE:=Double LTE Checknet Control
  PKGARCH:=all
endef

define Package/checknet/description
  Double LTE Checknet Control.
endef

define Package/checknet/conffiles
/etc/gcom/getinfo.gcom
/etc/gcom/defaultapn.gcom
/etc/config/checknet
endef

define Build/Compile
endef

define Package/checknet/install
	$(INSTALL_DIR) $(1)/etc/gcom $(1)/etc/config
	$(INSTALL_CONF) ./files/getinfo.gcom $(1)/etc/gcom/getinfo.gcom
	$(INSTALL_CONF) ./files/defaultapn.gcom $(1)/etc/gcom/defaultapn.gcom
	$(INSTALL_CONF) ./files/checknet.conf $(1)/etc/config/checknet
	$(INSTALL_DIR) $(1)/etc/init.d $(1)/usr/bin $(1)/www/cgi-bin
	$(INSTALL_BIN) ./files/checknet.init $(1)/etc/init.d/checknet
	$(INSTALL_BIN) ./files/checknet.sh $(1)/usr/bin/checknet
	$(INSTALL_BIN) ./files/cfglte.sh $(1)/usr/bin/cfglte
	$(INSTALL_BIN) ./files/getmwan.sh $(1)/usr/bin/getmwan
	$(INSTALL_BIN) ./files/mwan.lua $(1)/www/cgi-bin/mwan
endef

$(eval $(call BuildPackage,checknet))
