{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  nixosTests,
  boost,
  yaml-cpp,
  libsodium,
  sqlite,
  protobuf,
  openssl,
  systemd,
  mariadb-connector-c,
  postgresql,
  lua,
  openldap,
  geoip,
  curl,
  unixODBC,
  lmdb,
  tinycdb,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pdns";
  version = "4.9.2";

  src = fetchurl {
    url = "https://downloads.powerdns.com/releases/pdns-${finalAttrs.version}.tar.bz2";
    hash = "sha256-9XBkBCcEH0xcVHDRbv+VGnA4w1PdxGGydQKQzpmy48I=";
  };
  # redact configure flags from version output to reduce closure size
  patches = [ ./version.patch ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    boost
    mariadb-connector-c
    postgresql
    lua
    openldap
    sqlite
    protobuf
    geoip
    yaml-cpp
    libsodium
    curl
    unixODBC
    openssl
    systemd
    lmdb
    tinycdb
  ];

  configureFlags = [
    (lib.enableFeature stdenv.hostPlatform.is32bit "experimental-64bit-time_t-support-on-glibc")
    (lib.enableFeature false "silent-rules")
    (lib.enableFeature true "dns-over-tls")
    (lib.enableFeature true "unit-tests")
    (lib.enableFeature true "reproducible")
    (lib.enableFeature true "tools")
    (lib.enableFeature true "ixfrdist")
    (lib.enableFeature true "systemd")
    (lib.withFeature true "libsodium")
    (lib.withFeature true "sqlite3")
    (lib.withFeatureAs true "libcrypto" (lib.getDev openssl))
    (lib.withFeatureAs true "modules" "")
    (lib.withFeatureAs true "dynmodules" (
      lib.concatStringsSep " " [
        "bind"
        "geoip"
        "gmysql"
        "godbc"
        "gpgsql"
        "gsqlite3"
        "ldap"
        "lmdb"
        "lua2"
        "pipe"
        "remote"
        "tinydns"
      ]
    ))
    "sysconfdir=/etc/pdns"
  ];

  # We want the various utilities to look for the powerdns config in
  # /etc/pdns, but to actually install the sample config file in
  # $out
  installFlags = [ "sysconfdir=$(out)/etc/pdns" ];

  enableParallelBuilding = true;
  doCheck = true;

  passthru.tests = {
    nixos = nixosTests.powerdns;
  };

  __structuredAttrs = true;

  meta = with lib; {
    description = "Authoritative DNS server";
    homepage = "https://www.powerdns.com";
    platforms = platforms.unix;
    broken = stdenv.hostPlatform.isDarwin;
    license = licenses.gpl2Only;
    maintainers = with maintainers; [
      mic92
      disassembler
      nickcao
    ];
  };
})
