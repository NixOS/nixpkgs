{
  lib,
  stdenv,
  fetchurl,
  writeText,
}:

import ./versions.nix (
  { version, hash, ... }:
  stdenv.mkDerivation rec {
    pname = "zabbix-web";
    inherit version;

    src = fetchurl {
      url = "https://cdn.zabbix.com/zabbix/sources/stable/${lib.versions.majorMinor version}/zabbix-${version}.tar.gz";
      inherit hash;
    };

    phpConfig = writeText "zabbix.conf.php" ''
      <?php
        return require(getenv('ZABBIX_CONFIG'));
      ?>
    '';

    installPhase = ''
      mkdir -p $out/share/zabbix/
      cp -a ui/. $out/share/zabbix/
      cp ${phpConfig} $out/share/zabbix/conf/zabbix.conf.php
    '';

    meta = {
      description = "Enterprise-class open source distributed monitoring solution (web frontend)";
      homepage = "https://www.zabbix.com/";
      license =
        if (lib.versions.major version >= "7") then lib.licenses.agpl3Only else lib.licenses.gpl2Plus;
      maintainers = with lib.maintainers; [
        bstanderline
        mmahut
      ];
      platforms = lib.platforms.linux;
    };
  }
)
