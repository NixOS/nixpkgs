{ stdenv, fetchurl, pkgconfig
, boost, libyamlcpp, libsodium, sqlite, protobuf, botan2, openssl
, mysql57, postgresql, lua, openldap, geoip, curl, opendbx, unixODBC
}:

stdenv.mkDerivation rec {
  pname = "powerdns";
  version = "4.2.1";

  src = fetchurl {
    url = "https://downloads.powerdns.com/releases/pdns-${version}.tar.bz2";
    sha256 = "0a5al77rn4cd7v3g8c2q7627nf9b9g8dxg7yzz3b3jwgdfc1jl7n";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    boost mysql57.connector-c postgresql lua openldap sqlite protobuf geoip
    libyamlcpp libsodium curl opendbx unixODBC botan2 openssl
  ];

  # nix destroy with-modules arguments, when using configureFlags
  preConfigure = ''
    configureFlagsArray=(
      "--with-modules=bind gmysql geoip godbc gpgsql gsqlite3 ldap lua mydns opendbx pipe random remote"
      --with-sqlite3
      --with-socketdir=/var/lib/powerdns
      --with-libcrypto=${openssl.dev}
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
