{ stdenv, fetchurl, pkgconfig
, boost, libyamlcpp, libsodium, sqlite, protobuf, botan2, libressl
, mysql57, postgresql, lua, openldap, geoip, curl, opendbx, unixODBC
}:

stdenv.mkDerivation rec {
  name = "powerdns-${version}";
  version = "4.1.10";

  src = fetchurl {
    url = "https://downloads.powerdns.com/releases/pdns-${version}.tar.bz2";
    sha256 = "1iqmrg0dhf39gr2mq9d8r3s5c6yqkb5mm8grbbla5anajbgcyijs";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    boost mysql57.connector-c postgresql lua openldap sqlite protobuf geoip
    libyamlcpp libsodium curl opendbx unixODBC botan2 libressl
  ];

  # nix destroy with-modules arguments, when using configureFlags
  preConfigure = ''
    configureFlagsArray=(
      "--with-modules=bind gmysql geoip godbc gpgsql gsqlite3 ldap lua mydns opendbx pipe random remote"
      --with-sqlite3
      --with-socketdir=/var/lib/powerdns
      --with-libcrypto=${libressl.dev}
      --enable-libsodium
      --enable-botan
      --enable-tools
      --disable-dependency-tracking
      --disable-silent-rules
      --enable-reproducible
      --enable-unit-tests
    )
  '';

  enableParallelBuilding = true;
  doCheck = true;

  meta = with stdenv.lib; {
    description = "Authoritative DNS server";
    homepage = https://www.powerdns.com;
    platforms = platforms.unix;
    broken = stdenv.isDarwin;
    license = licenses.gpl2;
    maintainers = with maintainers; [ mic92 disassembler ];
  };
}
