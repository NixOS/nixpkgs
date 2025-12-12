{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  curl,
  libevent,
  libiconv,
  openssl,
  pcre,
  pcre2,
  zlib,
  buildPackages,
  odbcSupport ? true,
  unixODBC,
  snmpSupport ? stdenv.buildPlatform == stdenv.hostPlatform,
  net-snmp,
  sshSupport ? true,
  libssh2,
  sqliteSupport ? false,
  sqlite,
  mysqlSupport ? false,
  libmysqlclient,
  postgresqlSupport ? false,
  libpq,
}:

# ensure exactly one database type is selected
assert mysqlSupport -> !postgresqlSupport && !sqliteSupport;
assert postgresqlSupport -> !mysqlSupport && !sqliteSupport;
assert sqliteSupport -> !mysqlSupport && !postgresqlSupport;

let
  inherit (lib) optional optionalString;

  fake_mysql_config = buildPackages.writeShellScript "mysql_config" ''
    if [[ "$1" == "--version" ]]; then
      $PKG_CONFIG mysqlclient --modversion
    else
      $PKG_CONFIG mysqlclient $@
    fi
  '';

in
import ./versions.nix (
  { version, hash, ... }:
  stdenv.mkDerivation {
    pname = "zabbix-proxy";
    inherit version;

    src = fetchurl {
      url = "https://cdn.zabbix.com/zabbix/sources/stable/${lib.versions.majorMinor version}/zabbix-${version}.tar.gz";
      inherit hash;
    };

    enableParallelBuilding = true;

    nativeBuildInputs = [
      pkg-config
    ]
    ++ optional postgresqlSupport libpq.pg_config;
    buildInputs = [
      curl
      libevent
      libiconv
      openssl
      (if (lib.versions.major version >= "7" && lib.versions.minor version >= "4") then pcre2 else pcre)
      zlib
    ]
    ++ optional odbcSupport unixODBC
    ++ optional snmpSupport net-snmp
    ++ optional sqliteSupport sqlite
    ++ optional sshSupport libssh2
    ++ optional mysqlSupport libmysqlclient
    ++ optional postgresqlSupport libpq;

    configureFlags = [
      "--enable-ipv6"
      "--enable-proxy"
      "--with-iconv"
      "--with-libcurl"
      "--with-libevent"
      "--with-libpcre"
      "--with-openssl=${openssl.dev}"
      "--with-zlib=${zlib}"
    ]
    ++ optional odbcSupport "--with-unixodbc"
    ++ optional snmpSupport "--with-net-snmp"
    ++ optional sqliteSupport "--with-sqlite3=${sqlite.dev}"
    ++ optional sshSupport "--with-ssh2=${libssh2.dev}"
    ++ optional mysqlSupport "--with-mysql=${fake_mysql_config}"
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
    ''
    + optionalString sqliteSupport ''
      mkdir -p $out/share/zabbix/database/sqlite3
      cp -prvd database/sqlite3/schema.sql $out/share/zabbix/database/sqlite3/
    ''
    + optionalString mysqlSupport ''
      mkdir -p $out/share/zabbix/database/mysql
      cp -prvd database/mysql/schema.sql $out/share/zabbix/database/mysql/
    ''
    + optionalString postgresqlSupport ''
      mkdir -p $out/share/zabbix/database/postgresql
      cp -prvd database/postgresql/schema.sql $out/share/zabbix/database/postgresql/
    '';

    meta = {
      description = "Enterprise-class open source distributed monitoring solution (client-server proxy)";
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
