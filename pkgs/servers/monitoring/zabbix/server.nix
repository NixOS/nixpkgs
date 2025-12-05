{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  pkg-config,
  curl,
  libevent,
  libiconv,
  libxml2,
  openssl,
  pcre,
  pcre2,
  zlib,
  jabberSupport ? true,
  iksemel,
  ldapSupport ? true,
  openldap,
  odbcSupport ? true,
  unixODBC,
  snmpSupport ? true,
  net-snmp,
  sshSupport ? true,
  libssh2,
  mysqlSupport ? false,
  libmysqlclient,
  postgresqlSupport ? false,
  libpq,
  ipmiSupport ? false,
  openipmi,
}:

# ensure exactly one primary database type is selected
assert mysqlSupport -> !postgresqlSupport;
assert postgresqlSupport -> !mysqlSupport;

let
  inherit (lib) optional optionalString;
in
import ./versions.nix (
  { version, hash, ... }:
  stdenv.mkDerivation {
    pname = "zabbix-server";
    inherit version;

    src = fetchurl {
      url = "https://cdn.zabbix.com/zabbix/sources/stable/${lib.versions.majorMinor version}/zabbix-${version}.tar.gz";
      inherit hash;
    };

    enableParallelBuilding = true;

    nativeBuildInputs = [
      autoreconfHook
      pkg-config
    ]
    ++ optional postgresqlSupport libpq.pg_config;
    buildInputs = [
      curl
      libevent
      libiconv
      libxml2
      openssl
      (if lib.versionAtLeast version "7.4" then pcre2 else pcre)
      zlib
    ]
    ++ optional odbcSupport unixODBC
    ++ optional jabberSupport iksemel
    ++ optional ldapSupport openldap
    ++ optional snmpSupport net-snmp
    ++ optional sshSupport libssh2
    ++ optional mysqlSupport libmysqlclient
    ++ optional postgresqlSupport libpq
    ++ optional ipmiSupport openipmi;

    configureFlags = [
      "--enable-ipv6"
      "--enable-server"
      "--with-iconv"
      "--with-libcurl"
      "--with-libevent"
      "--with-libpcre"
      "--with-libxml2"
      "--with-openssl=${openssl.dev}"
      "--with-zlib=${zlib}"
    ]
    ++ optional odbcSupport "--with-unixodbc"
    ++ optional jabberSupport "--with-jabber"
    ++ optional ldapSupport "--with-ldap=${openldap.dev}"
    ++ optional snmpSupport "--with-net-snmp"
    ++ optional sshSupport "--with-ssh2=${libssh2.dev}"
    ++ optional mysqlSupport "--with-mysql"
    ++ optional postgresqlSupport "--with-postgresql"
    ++ optional ipmiSupport "--with-openipmi=${openipmi.dev}";

    prePatch = ''
      find database -name data.sql -exec sed -i 's|/usr/bin/||g' {} +
    '';

    preAutoreconf = ''
      for i in $(find . -type f -name "*.m4"); do
        substituteInPlace $i \
          --replace 'test -x "$PKG_CONFIG"' 'type -P "$PKG_CONFIG" >/dev/null'
      done
    '';

    postInstall = ''
      mkdir -p $out/share/zabbix/database/
      cp -r include $out/
    ''
    + optionalString mysqlSupport ''
      mkdir -p $out/share/zabbix/database/mysql
      cp -prvd database/mysql/*.sql $out/share/zabbix/database/mysql/
    ''
    + optionalString postgresqlSupport ''
      mkdir -p $out/share/zabbix/database/postgresql
      cp -prvd database/postgresql/*.sql $out/share/zabbix/database/postgresql/
    '';

    meta = {
      description = "Enterprise-class open source distributed monitoring solution";
      homepage = "https://www.zabbix.com/";
      license =
        if (lib.versions.major version >= "7") then lib.licenses.agpl3Only else lib.licenses.gpl2Plus;
      maintainers = with lib.maintainers; [
        bstanderline
        mmahut
        psyanticy
      ];
      platforms = lib.platforms.linux;
    };
  }
)
