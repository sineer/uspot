include $(TOPDIR)/rules.mk

PKG_NAME:=ubispot
PKG_RELEASE:=1

PKG_LICENSE:=GPL-2.0
PKG_MAINTAINER:=Thibaut VARÈNE <hacks@slashdirt.org>

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

define Package/ubispot
  SUBMENU:=Captive Portals
  SECTION:=net
  CATEGORY:=Network
  TITLE:=ubispot hotspot daemon
  EXTRA_DEPENDS:=ucode (>= 2023-11-07)
  DEPENDS:=+conntrack \
	   +libblobmsg-json +liblucihttp-ucode +libradcli +libubox +libubus +libuci \
	   +ratelimit +ubispotfilter \
	   +ucode +ucode-mod-log +ucode-mod-math +ucode-mod-nl80211 +ucode-mod-rtnl +uhttpd-mod-ucode +ucode-mod-uloop
  CONFLICTS:=uspot
endef

define Package/ubispot/description
  Ubi.tel fork of uspot with pre-configured wifi login page radius uam handler.
endef

define Package/ubispot/conffiles
/etc/config/ubispot
endef


define Package/ubispot-www
  SUBMENU:=Captive Portals
  SECTION:=net
  CATEGORY:=Network
  TITLE:=ubispot default user interface files
  DEPENDS:=+ubispot
  PKGARCH:=all
  CONFLICTS:=uspot-www
endef

define Package/ubispot-www/description
  This package provides CSS and HTML templates for ubispot UI.
  This package must be installed with ubispot unless a local alternative is provided.
endef

define Package/ubispotfilter
  SECTION:=net
  CATEGORY:=Network
  TITLE:=ubispot firewall interface
  EXTRA_DEPENDS:=ucode (>= 2023-11-07)
  DEPENDS:=+ucode +ucode-mod-log +ucode-mod-uloop +ucode-mod-rtnl +nftables-json +conntrack
  PKGARCH:=all
  CONFLICTS:=uspotfilter
endef

define Package/ubispotfilter/description
  This package provides the nftables firewall interface to ubispot.
  It is compatible with firewall4.
endef

define Package/ubispot/install
	$(INSTALL_DIR) $(1)/usr/bin $(1)/usr/share $(1)/usr/lib/ucode $(1)/etc/init.d $(1)/etc/config
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/radius-client $(1)/usr/bin/radius-client
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/ubispot-das $(1)/usr/bin/ubispot-das
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/libuam.so $(1)/usr/lib/ucode/uam.so
	$(INSTALL_CONF) ./files/etc/config/ubispot $(1)/etc/config/ubispot
	$(INSTALL_BIN) ./files/etc/init.d/ubispot $(1)/etc/init.d/ubispot
	$(CP) ./files/usr/bin $(1)/usr/
	$(CP) ./files/usr/share/ubispot $(1)/usr/share/
endef

define Package/ubispot-www/install
	$(CP) ./files/www-ubispot $(1)/
endef

define Package/ubispotfilter/install
	$(INSTALL_DIR) $(1)/usr/share $(1)/etc/init.d
	$(INSTALL_BIN) ./files/etc/init.d/ubispotfilter $(1)/etc/init.d/ubispotfilter
	$(CP) ./files/usr/share/ubispotfilter $(1)/usr/share/
endef

$(eval $(call BuildPackage,ubispot))
$(eval $(call BuildPackage,ubispot-www))
$(eval $(call BuildPackage,ubispotfilter))
