{ stdenv, fetchurl, pkgconfig, curl, openssl, zlib, pcre, libevent, mysql, libiconv, libxml2 }:

let
  version = "4.0.9";

  src = fetchurl {
    url = "https://netix.dl.sourceforge.net/project/zabbix/ZABBIX%20Latest%20Stable/${version}/zabbix-${version}.tar.gz";
    sha256 = "aa0bc9b5e5ca8e1b49b7551e2c5d86e0342c8630cba3a0b0e0e5d9c846e784d1";
  };

in

{

  server = stdenv.mkDerivation {
    name = "zabbix-${version}";

    inherit src;
    NIX_CFLAGS_COMPILE = "-L${mysql.connector-c}/lib/mysql -I${mysql.connector-c}/include/mysql";
    configureFlags = [
      "--enable-server"
      "--with-mysql"
      "--with-libcurl"
      "--with-libxml2"
      "--with-zlib"
      "--with-libpcre=${pcre.dev}"
      "--with-libevent=${libevent.dev}"
      "--with-iconv=${libiconv}"
      "--with-openssl=${openssl.dev}"
    ];

    nativeBuildInputs = [ pkgconfig ];
    buildInputs = [ mysql curl openssl zlib pcre libxml2 libevent ] ;

    postInstall =
      ''
        mkdir -p $out/share/zabbix
        cp -prvd frontends/php $out/share/zabbix/php
        mkdir -p $out/share/zabbix/db/data
        cp -prvd database/mysql/data.sql $out/share/zabbix/db/data/data.sql
        cp -prvd database/mysql/images.sql $out/share/zabbix/db/data/images.sql
        mkdir -p $out/share/zabbix/db/schema
        cp -prvd database/mysql/schema.sql $out/share/zabbix/db/schema/mysql.sql
      '';

    meta = with stdenv.lib; {
      description = "An enterprise-class open source distributed monitoring solution (server)";
      homepage = http://www.zabbix.com/;
      license = licenses.gpl2;
      maintainers = [ maintainers.psyanticy ];
      platforms = platforms.linux;
    };
  };

  agent = stdenv.mkDerivation {
    name = "zabbix-agent-${version}";

    inherit src;

    configureFlags = [
      "--enable-agent"
      "--with-libpcre=${pcre.dev}"
      "--with-iconv=${libiconv}"
      "--with-openssl=${openssl.dev}"
    ];
    buildInputs = [ pcre libiconv openssl ];

    meta = with stdenv.lib; {
      description = "An enterprise-class open source distributed monitoring solution (client-side agent)";
      homepage = http://www.zabbix.com/;
      license = licenses.gpl2;
      maintainers = [ maintainers.psyanticy ];
      platforms = platforms.linux;
    };
  };
}