{ lib, stdenv, fetchurl, pkg-config, libevent, libiconv, openssl, pcre, zlib
, odbcSupport ? true, unixODBC
, snmpSupport ? stdenv.buildPlatform == stdenv.hostPlatform, net-snmp
, sshSupport ? true, libssh2
, sqliteSupport ? false, sqlite
, mysqlSupport ? false, libmysqlclient
, postgresqlSupport ? false, postgresql
}:

# ensure exactly one database type is selected
assert mysqlSupport -> !postgresqlSupport && !sqliteSupport;
assert postgresqlSupport -> !mysqlSupport && !sqliteSupport;
assert sqliteSupport -> !mysqlSupport && !postgresqlSupport;

let
  inherit (lib) optional optionalString;
in
  import ./versions.nix ({ version, hash, ... }:
    stdenv.mkDerivation {
      pname = "zabbix-proxy";
      inherit version;

      src = fetchurl {
        url = "https://cdn.zabbix.com/zabbix/sources/stable/${lib.versions.majorMinor version}/zabbix-${version}.tar.gz";
        inherit hash;
      };

      nativeBuildInputs = [ pkg-config ];
      buildInputs = [
        libevent
        libiconv
        openssl
        pcre
        zlib
      ]
      ++ optional odbcSupport unixODBC
      ++ optional snmpSupport net-snmp
      ++ optional sqliteSupport sqlite
      ++ optional sshSupport libssh2
      ++ optional mysqlSupport libmysqlclient
      ++ optional postgresqlSupport postgresql;

      configureFlags = [
        "--enable-ipv6"
        "--enable-proxy"
        "--with-iconv"
        "--with-libevent"
        "--with-libpcre"
        "--with-openssl=${openssl.dev}"
        "--with-zlib=${zlib}"
      ]
      ++ optional odbcSupport "--with-unixodbc"
      ++ optional snmpSupport "--with-net-snmp"
      ++ optional sqliteSupport "--with-sqlite3=${sqlite.dev}"
      ++ optional sshSupport "--with-ssh2=${libssh2.dev}"
      ++ optional mysqlSupport "--with-mysql"
      ++ optional postgresqlSupport "--with-postgresql";

      prePatch = ''
        find database -name data.sql -exec sed -i 's|/usr/bin/||g' {} +
      '';

      makeFlags = [
        "AR:=$(AR)"
        "RANLIB:=$(RANLIB)"
      ];

      postInstall = ''
        mkdir -p $out/share/zabbix/database/
      '' + optionalString sqliteSupport ''
        mkdir -p $out/share/zabbix/database/sqlite3
        cp -prvd database/sqlite3/schema.sql $out/share/zabbix/database/sqlite3/
      '' + optionalString mysqlSupport ''
        mkdir -p $out/share/zabbix/database/mysql
        cp -prvd database/mysql/schema.sql $out/share/zabbix/database/mysql/
      '' + optionalString postgresqlSupport ''
        mkdir -p $out/share/zabbix/database/postgresql
        cp -prvd database/postgresql/schema.sql $out/share/zabbix/database/postgresql/
      '';

      meta = with lib; {
        description = "Enterprise-class open source distributed monitoring solution (client-server proxy)";
        homepage = "https://www.zabbix.com/";
        license = licenses.gpl2Plus;
        maintainers = [ maintainers.mmahut ];
        platforms = platforms.linux;
      };
    })
