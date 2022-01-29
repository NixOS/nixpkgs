{ lib, stdenv, fetchurl, pkg-config, nixosTests
, boost, libyamlcpp, libsodium, sqlite, protobuf, openssl, systemd
, mariadb-connector-c, postgresql, lua, openldap, geoip, curl, unixODBC
}:

stdenv.mkDerivation rec {
  pname = "powerdns";
  version = "4.5.3";

  src = fetchurl {
    url = "https://downloads.powerdns.com/releases/pdns-${version}.tar.bz2";
    sha256 = "0kq4if44hw7d08im3k25l2wpm8sa2g3cpmqxd7crnhkyg1lxjq0w";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    boost mariadb-connector-c postgresql lua openldap sqlite protobuf geoip
    libyamlcpp libsodium curl unixODBC openssl systemd
  ];

  # nix destroy with-modules arguments, when using configureFlags
  preConfigure = ''
    configureFlagsArray=(
      "--with-modules=bind gmysql geoip godbc gpgsql gsqlite3 ldap lua2 pipe random remote"
      --with-sqlite3
      --with-libcrypto=${openssl.dev}
      --with-libsodium
      --enable-tools
      --disable-dependency-tracking
      --disable-silent-rules
      --enable-reproducible
      --enable-unit-tests
      --enable-systemd
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
    maintainers = with maintainers; [ mic92 disassembler ];
  };
}
