{ stdenv, fetchurl, pkgconfig
, boost, libyamlcpp, libsodium, sqlite, protobuf, botan2
, mysql57, postgresql, lua, openldap, geoip, curl, opendbx, unixODBC
}:

stdenv.mkDerivation rec {
  name = "powerdns-${version}";
  version = "4.1.4";

  src = fetchurl {
    url = "https://downloads.powerdns.com/releases/pdns-${version}.tar.bz2";
    sha256 = "1m9yhzrxh315gv855c590b2qc8bx31rrnl72pqxrnlix701qch79";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    boost mysql57.connector-c postgresql lua openldap sqlite protobuf geoip
    libyamlcpp libsodium curl opendbx unixODBC botan2
  ];

  patches = [
    # checksum type not found, maybe a dependency is to old?
    ./skip-sha384-test.patch
  ];

  # nix destroy with-modules arguments, when using configureFlags
  preConfigure = ''
    configureFlagsArray=(
      "--with-modules=bind gmysql geoip godbc gpgsql gsqlite3 ldap lua mydns opendbx pipe random remote"
      --with-sqlite3
      --with-socketdir=/var/lib/powerdns
      --enable-libsodium
      --enable-botan
      --enable-tools
      --disable-dependency-tracking
      --disable-silent-rules
      --enable-reproducible
      --enable-unit-tests
    )
  '';

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Authoritative DNS server";
    homepage = https://www.powerdns.com;
    platforms = platforms.linux;
    # cannot find postgresql libs on macos x
    license = licenses.gpl2;
    maintainers = with maintainers; [ mic92 disassembler ];
  };
}
