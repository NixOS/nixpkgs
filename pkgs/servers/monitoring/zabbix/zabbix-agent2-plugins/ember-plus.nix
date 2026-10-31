{
  lib,
  buildGoModule,
  fetchurl,
}:

import ../versions.nix (
  { version, emberPlusHash, ... }:
  buildGoModule (finalAttrs: {
    pname = "zabbix-agent2-plugin-ember-plus";
    inherit version;

    src = fetchurl {
      url = "https://cdn.zabbix.com/zabbix-agent2-plugins/sources/ember-plus/zabbix-agent2-plugin-ember-plus-${finalAttrs.version}.tar.gz";
      hash = emberPlusHash;
    };

    vendorHash = null;

    meta = {
      description = "Zabbix agent2 plugin for monitoring Ember Plus";
      mainProgram = "ember-plus";
      homepage = "https://www.zabbix.com/documentation/current/en/manual/appendix/config/zabbix_agent2_plugins/ember_plus_plugin";
      license =
        if (lib.versions.major finalAttrs.version >= "7") then
          lib.licenses.agpl3Only
        else
          lib.licenses.gpl2Plus;
      maintainers = with lib.maintainers; [ thelolcoder2007 ];
      platforms = lib.platforms.linux;
    };
  })
)
