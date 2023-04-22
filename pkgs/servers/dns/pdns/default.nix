{ lib, stdenv, fetchurl, pkg-config, nixosTests
, boost, yaml-cpp, libsodium, sqlite, protobuf, openssl, systemd
, mariadb-connector-c, postgresql, lua, openldap, geoip, curl, unixODBC, lmdb, tinycdb
}:

stdenv.mkDerivation rec {
  pname = "pdns";
  version = "4.7.4";

  src = fetchurl {
    url = "https://downloads.powerdns.com/releases/pdns-${version}.tar.bz2";
    hash = "sha256-dGndgft98RGX9JY4+knO/5+XMiX8j5xxYLC/wAoudHE=";
  };
  # redact configure flags from version output to reduce closure size
  patches = [ ./version.patch ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    boost mariadb-connector-c postgresql lua openldap sqlite protobuf geoip
    yaml-cpp libsodium curl unixODBC openssl systemd lmdb tinycdb
  ];

  # Configure phase requires 64-bit time_t even on 32-bit platforms.
  env.NIX_CFLAGS_COMPILE = toString (lib.optionals stdenv.hostPlatform.is32bit [
    "-D_TIME_BITS=64" "-D_FILE_OFFSET_BITS=64"
  ]);

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
  ];

  # nix destroy with-modules arguments, when using configureFlags
  preConfigure = ''
    configureFlagsArray+=(
      "--with-modules="
      "--with-dynmodules=bind geoip gmysql godbc gpgsql gsqlite3 ldap lmdb lua2 pipe remote tinydns"
    )
  '';

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
    license = licenses.gpl2;
    maintainers = with maintainers; [ mic92 disassembler nickcao ];
  };
}
