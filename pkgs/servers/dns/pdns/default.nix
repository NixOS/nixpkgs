{ lib, stdenv, fetchurl, pkg-config, nixosTests
, boost, libyamlcpp, libsodium, sqlite, protobuf, openssl, systemd
, mariadb-connector-c, postgresql, lua, openldap, geoip, curl, unixODBC, lmdb, tinycdb
}:

stdenv.mkDerivation rec {
  pname = "powerdns";
  version = "4.6.1";

  src = fetchurl {
    url = "https://downloads.powerdns.com/releases/pdns-${version}.tar.bz2";
    sha256 = "sha256-eRKxSIfWKEUYX3zktH21gOqnuLiX3LHJVV3+D6xe+uM=";
  };
  # redact configure flags from version output to reduce closure size
  patches = [ ./version.patch ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    boost mariadb-connector-c postgresql lua openldap sqlite protobuf geoip
    libyamlcpp libsodium curl unixODBC openssl systemd lmdb tinycdb
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
