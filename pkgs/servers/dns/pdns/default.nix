{ lib, stdenv, fetchurl, pkg-config, nixosTests
, boost, libyamlcpp, libsodium, sqlite, protobuf, openssl, systemd
, mariadb-connector-c, postgresql, lua, openldap, geoip, curl, unixODBC, lmdb, tinycdb
}:

stdenv.mkDerivation rec {
  pname = "powerdns";
  version = "4.6.2";

  src = fetchurl {
    url = "https://downloads.powerdns.com/releases/pdns-${version}.tar.bz2";
    hash = "sha256-9EOEiUS7Ebu0hQIhYTs6Af+1f+vyZx2myqVzYu4LGbg=";
  };
  # redact configure flags from version output to reduce closure size
  patches = [ ./version.patch ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    boost mariadb-connector-c postgresql lua openldap sqlite protobuf geoip
    libyamlcpp libsodium curl unixODBC openssl systemd lmdb tinycdb
  ];

  # Configure phase requires 64-bit time_t even on 32-bit platforms.
  NIX_CFLAGS_COMPILE = lib.optionals stdenv.hostPlatform.is32bit [
    "-D_TIME_BITS=64" "-D_FILE_OFFSET_BITS=64"
  ];

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
