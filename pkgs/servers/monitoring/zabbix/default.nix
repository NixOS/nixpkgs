{ stdenv, fetchurl, pkgconfig, postgresql, curl, openssl, zlib, pcre, libevent, libiconv }:

let
  version = "3.4.4";

  src = fetchurl {
    url = "mirror://sourceforge/zabbix/zabbix-${version}.tar.gz";
    sha256 = "192klcwypbcsfs4q7jrs1cqfqk8pzwrg7dhaxhig6hfll1r4xs1f";
  };

in

{

  server = stdenv.mkDerivation {
    name = "zabbix-${version}";

    inherit src;

    configureFlags = [
      "--enable-server"
      "--with-postgresql"
      "--with-libcurl"
      "--with-libpcre=${pcre.dev}"
      "--with-libevent=${libevent.dev}"
      "--with-iconv=${libiconv}"
    ];

    nativeBuildInputs = [ pkgconfig ];
    buildInputs = [ postgresql curl openssl zlib pcre libevent libiconv ];

    postInstall =
      ''
        mkdir -p $out/share/zabbix
        cp -prvd frontends/php $out/share/zabbix/php
        mkdir -p $out/share/zabbix/db/data
        cp -prvd database/postgresql/data.sql $out/share/zabbix/db/data/data.sql
        cp -prvd database/postgresql/images.sql $out/share/zabbix/db/data/images_pgsql.sql
        mkdir -p $out/share/zabbix/db/schema
        cp -prvd database/postgresql/schema.sql $out/share/zabbix/db/schema/postgresql.sql
      '';

    meta = with stdenv.lib; {
      description = "An enterprise-class open source distributed monitoring solution (server)";
      homepage = http://www.zabbix.com/;
      license = licenses.gpl2;
      maintainers = [ maintainers.srhb ];
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
    ];

    buildInputs = [ pcre libiconv ];

    meta = with stdenv.lib; {
      description = "An enterprise-class open source distributed monitoring solution (client-side agent)";
      homepage = http://www.zabbix.com/;
      license = licenses.gpl2;
      maintainers = [ maintainers.srhb ];
      platforms = platforms.linux;
    };
  };

}
