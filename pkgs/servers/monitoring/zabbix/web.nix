{ stdenv, fetchurl, writeText }:

import ./versions.nix ({ version, sha256 }:
  stdenv.mkDerivation rec {
    pname = "zabbix-web";
    inherit version;

    src = fetchurl {
      url = "https://cdn.zabbix.com/zabbix/sources/stable/${stdenv.lib.versions.majorMinor version}/zabbix-${version}.tar.gz";
      inherit sha256;
    };

    phpConfig = writeText "zabbix.conf.php" ''
    <?php
      return require(getenv('ZABBIX_CONFIG'));
    ?>
    '';

    installPhase = ''
      mkdir -p $out/share/zabbix/
      cp -a frontends/php/. $out/share/zabbix/
      cp ${phpConfig} $out/share/zabbix/conf/zabbix.conf.php
    '';

    meta = with stdenv.lib; {
      description = "An enterprise-class open source distributed monitoring solution (web frontend)";
      homepage = "https://www.zabbix.com/";
      license = licenses.gpl2;
      maintainers = [ maintainers.mmahut ];
      platforms = platforms.linux;
    };
  })
