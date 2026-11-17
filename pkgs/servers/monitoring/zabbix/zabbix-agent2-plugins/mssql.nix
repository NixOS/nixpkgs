{
  lib,
  buildGoModule,
  fetchurl,
}:

import ../versions.nix (
  { version, mssqlHash, ... }:
  buildGoModule (finalAttrs: {
    pname = "zabbix-agent2-plugin-mssql";
    inherit version;

    src = fetchurl {
      url = "https://cdn.zabbix.com/zabbix-agent2-plugins/sources/mssql/zabbix-agent2-plugin-mssql-${finalAttrs.version}.tar.gz";
      hash = mssqlHash;
    };

    vendorHash = null;

    meta = {
      description = "Zabbix agent2 plugin for monitoring Microsoft SQL servers";
      mainProgram = "mssql";
      homepage = "https://www.zabbix.com/documentation/current/en/manual/appendix/config/zabbix_agent2_plugins/mssql_plugin";
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
