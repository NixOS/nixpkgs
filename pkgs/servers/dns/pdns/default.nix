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
  version = "4.9.1";

  src = fetchurl {
    url = "https://downloads.powerdns.com/releases/pdns-${finalAttrs.version}.tar.bz2";
    hash = "sha256-MNlnG48IR3Tby6IPWlOjE00IIqsu3D75aNoDDmMN0Jo=";
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

  # Configure phase requires 64-bit time_t even on 32-bit platforms.
  env.NIX_CFLAGS_COMPILE = toString (
    lib.optionals stdenv.hostPlatform.is32bit [
      "-D_TIME_BITS=64"
      "-D_FILE_OFFSET_BITS=64"
    ]
  );

  configureFlags = [
    "--disable-silent-rules"
    "--enable-dns-over-tls"
    "--enable-unit-tests"
    "--enable-reproducible"
    "--enable-tools"
    "--enable-ixfrdist"
    "--enable-systemd"
    "--with-libsodium"
    "--with-sqlite3"
    "--with-libcrypto=${openssl.dev}"
    "sysconfdir=/etc/pdns"
  ];

  # nix destroy with-modules arguments, when using configureFlags
  preConfigure = ''
    configureFlagsArray+=(
      "--with-modules="
      "--with-dynmodules=bind geoip gmysql godbc gpgsql gsqlite3 ldap lmdb lua2 pipe remote tinydns"
    )
  '';

  # We want the various utilities to look for the powerdns config in
  # /etc/pdns, but to actually install the sample config file in
  # $out
  installFlags = [ "sysconfdir=$(out)/etc/pdns" ];

  enableParallelBuilding = true;
  doCheck = true;

  passthru.tests = {
    nixos = nixosTests.powerdns;
  };

  meta = with lib; {
    description = "Authoritative DNS server";
    homepage = "https://www.powerdns.com";
    platforms = platforms.unix;
    broken = stdenv.isDarwin;
    license = licenses.gpl2Only;
    maintainers = with maintainers; [
      mic92
      disassembler
      nickcao
    ];
  };
})
