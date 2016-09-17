{ stdenv, fetchurl, pkgconfig, postgresql, curl, openssl, zlib, gettext
, net_snmp , libssh2, openldap
, enableJabber ? false, minmay ? null
, enableSnmp ? false
, enableSsh ? false
, enableLdap ? false
}:

assert enableJabber -> minmay != null;

let

  version = "2.2.2";
  branch = "2.2";

  src = fetchurl {
    url = "mirror://sourceforge/zabbix/zabbix-${version}.tar.gz";
    sha256 = "1gmjbjmajdllzd7akihb5kg4l2gf0ii9c16fq8mlla37sshzj3p0";
  };

  preConfigure =
    ''
      substituteInPlace ./configure \
        --replace " -static" "" \
        ${stdenv.lib.optionalString (stdenv.cc.libc != null) ''
          --replace /usr/include/iconv.h ${stdenv.lib.getDev stdenv.cc.libc}/include/iconv.h
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
    ]
    ++ stdenv.lib.optional enableJabber "--with-jabber=${minmay}"
    ++ stdenv.lib.optional enableSnmp "--with-net-snmp"
    ++ stdenv.lib.optional enableSsh "--with-ssh2=${libssh2.dev}"
    ++ stdenv.lib.optional enableLdap "--with-ldap=${openldap.dev}";

    postPatch = ''
      sed -i -e 's/iksemel/minmay/g' configure src/libs/zbxmedia/jabber.c
      sed -i \
        -e '/^static ikstransport/,/}/d' \
        -e 's/iks_connect_with\(.*\), &zbx_iks_transport/mmay_connect_via\1/' \
        -e 's/iks/mmay/g' -e 's/IKS/MMAY/g' src/libs/zbxmedia/jabber.c
    '';

    buildInputs = [ pkgconfig postgresql curl openssl zlib ]
      ++ stdenv.lib.optional enableSnmp net_snmp
      ++ stdenv.lib.optional enableSsh libssh2
      ++ stdenv.lib.optional enableLdap openldap;

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
      inherit branch;
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

    meta = with stdenv.lib; {
      inherit branch;
      description = "An enterprise-class open source distributed monitoring solution (client-side agent)";
      homepage = http://www.zabbix.com/;
      license = licenses.gpl2;
      maintainers = [ maintainers.eelco ];
      platforms = platforms.linux;
    };
  };

}
