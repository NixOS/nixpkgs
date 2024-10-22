{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libiconv,
  openssl,
  pcre,
}:

import ./versions.nix (
  { version, hash, ... }:
  stdenv.mkDerivation {
    pname = "zabbix-agent";
    inherit version;

    src = fetchurl {
      url = "https://cdn.zabbix.com/zabbix/sources/stable/${lib.versions.majorMinor version}/zabbix-${version}.tar.gz";
      inherit hash;
    };

    nativeBuildInputs = [ pkg-config ];
    buildInputs = [
      libiconv
      openssl
      pcre
    ];

    configureFlags = [
      "--enable-agent"
      "--enable-ipv6"
      "--with-iconv"
      "--with-libpcre"
      "--with-openssl=${openssl.dev}"
    ];
    makeFlags = [
      "AR:=$(AR)"
      "RANLIB:=$(RANLIB)"
    ];

    postInstall = ''
      cp conf/zabbix_agentd/*.conf $out/etc/zabbix_agentd.conf.d/
    '';

    meta = {
      description = "Enterprise-class open source distributed monitoring solution (client-side agent)";
      homepage = "https://www.zabbix.com/";
      license =
        if (lib.versions.major version >= "7") then lib.licenses.agpl3Only else lib.licenses.gpl2Plus;
      maintainers = with lib.maintainers; [
        mmahut
        psyanticy
      ];
      platforms = lib.platforms.unix;
    };
  }
)
