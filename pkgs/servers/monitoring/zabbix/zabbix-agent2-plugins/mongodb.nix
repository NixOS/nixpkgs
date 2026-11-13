{
  lib,
  buildGoModule,
  fetchurl,
}:

import ../versions.nix (
  { version, mongodbHash, ... }:
  buildGoModule (finalAttrs: {
    pname = "zabbix-agent2-plugin-mongodb";
    inherit version;

    src = fetchurl {
      url = "https://cdn.zabbix.com/zabbix-agent2-plugins/sources/mongodb/zabbix-agent2-plugin-mongodb-${finalAttrs.version}.tar.gz";
      hash = mongodbHash;
    };

    vendorHash = null;

    meta = {
      description = "Zabbix agent2 plugin for monitoring Mongodb";
      mainProgram = "mongodb";
      homepage = "https://www.zabbix.com/documentation/current/en/manual/appendix/config/zabbix_agent2_plugins/mongodb_plugin";
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
