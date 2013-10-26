{ stdenv, fetchurl, pkgconfig, postgresql, curl, openssl, zlib, gettext
, enableJabber ? false, minmay ? null }:

assert enableJabber -> minmay != null;

let

  version = "2.0.9";

  src = fetchurl {
    url = "mirror://sourceforge/zabbix/zabbix-${version}.tar.gz";
    sha256 = "057fjqww0qzs56nm8m3c36kbrhwriysvjvqzgwm9j2bg9ylixvym";
  };

  preConfigure =
    ''
      substituteInPlace ./configure \
        --replace " -static" "" \
        ${stdenv.lib.optionalString (stdenv.gcc.libc != null) ''
          --replace /usr/include/iconv.h ${stdenv.gcc.libc}/include/iconv.h
        ''}
    '';

in

{
  recurseForDerivations = true;

  server = stdenv.mkDerivation {
    name = "zabbix-${version}";

    inherit src preConfigure;

    configureFlags = [
      "--enable-agent"
      "--enable-server"
      "--with-postgresql"
      "--with-libcurl"
      "--with-gettext"
    ] ++ stdenv.lib.optional enableJabber "--with-jabber=${minmay}";

    postPatch = ''
      sed -i -e 's/iksemel/minmay/g' configure src/libs/zbxmedia/jabber.c
      sed -i \
        -e '/^static ikstransport/,/}/d' \
        -e 's/iks_connect_with\(.*\), &zbx_iks_transport/mmay_connect_via\1/' \
        -e 's/iks/mmay/g' -e 's/IKS/MMAY/g' src/libs/zbxmedia/jabber.c
    '';

    buildInputs = [ pkgconfig postgresql curl openssl zlib ];

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

    meta = {
      description = "An enterprise-class open source distributed monitoring solution";
      homepage = http://www.zabbix.com/;
      license = "GPL";
      maintainers = [ stdenv.lib.maintainers.eelco ];
      platforms = stdenv.lib.platforms.linux;
    };
  };

  agent = stdenv.mkDerivation {
    name = "zabbix-agent-${version}";

    inherit src preConfigure;

    configureFlags = "--enable-agent";

    meta = {
      description = "An enterprise-class open source distributed monitoring solution (client-side agent)";
      homepage = http://www.zabbix.com/;
      license = "GPL";
      maintainers = [ stdenv.lib.maintainers.eelco ];
      platforms = stdenv.lib.platforms.all;
    };
  };

}
