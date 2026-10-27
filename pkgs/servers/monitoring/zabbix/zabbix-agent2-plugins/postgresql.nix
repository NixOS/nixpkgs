{
  lib,
  buildGoModule,
  fetchurl,
}:

import ../versions.nix (
  { version, postgresqlHash, ... }:
  buildGoModule (finalAttrs: {
    pname = "zabbix-agent2-plugin-postgresql";
    inherit version;

    src = fetchurl {
      url = "https://cdn.zabbix.com/zabbix-agent2-plugins/sources/postgresql/zabbix-agent2-plugin-postgresql-${finalAttrs.version}.tar.gz";
      hash = postgresqlHash;
    };

    vendorHash = null;

    meta = {
      description = "Required tool for Zabbix agent integrated PostgreSQL monitoring";
      mainProgram = "postgresql";
      homepage = "https://www.zabbix.com/integrations/postgresql";
      license =
        if (lib.versions.major finalAttrs.version >= "7") then
          lib.licenses.agpl3Only
        else
          lib.licenses.gpl2Plus;
      maintainers = with lib.maintainers; [
        gador
        thelolcoder2007
      ];
      platforms = lib.platforms.linux;
    };
  })
)
