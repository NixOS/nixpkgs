{ stdenv, fetchurl, pkgconfig, libiconv, openssl, pcre }:

import ./versions.nix ({ version, sha256 }:
  stdenv.mkDerivation {
    pname = "zabbix-agent";
    inherit version;

    src = fetchurl {
      url = "https://cdn.zabbix.com/zabbix/sources/stable/${stdenv.lib.versions.majorMinor version}/zabbix-${version}.tar.gz";
      inherit sha256;
    };

    nativeBuildInputs = [ pkgconfig ];
    buildInputs = [
      libiconv
      openssl
      pcre
    ];

    configureFlags = [
      "--enable-agent"
      "--with-iconv"
      "--with-libpcre"
      "--with-openssl=${openssl.dev}"
    ];

    postInstall = ''
      cp conf/zabbix_agentd/*.conf $out/etc/zabbix_agentd.conf.d/
    '';

    meta = with stdenv.lib; {
      description = "An enterprise-class open source distributed monitoring solution (client-side agent)";
      homepage = "https://www.zabbix.com/";
      license = licenses.gpl2;
      maintainers = with maintainers; [ mmahut psyanticy ];
      platforms = platforms.linux;
    };
  })
