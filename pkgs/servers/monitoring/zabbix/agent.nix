{ lib, stdenv, fetchurl, pkg-config, libiconv, openssl, pcre }:

import ./versions.nix ({ version, url, hash, ... }:
  stdenv.mkDerivation {
    pname = "zabbix-agent";
    inherit version;

    src = fetchurl {
      inherit url hash;
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

    meta = with lib; {
      description = "An enterprise-class open source distributed monitoring solution (client-side agent)";
      homepage = "https://www.zabbix.com/";
      license = licenses.gpl2;
      maintainers = with maintainers; [ mmahut psyanticy ];
      platforms = platforms.linux;
    };
  })
