{ stdenv, fetchurl, pkgconfig,
  boost, libyamlcpp, libsodium, sqlite, protobuf,
  libmysql, postgresql, lua, openldap, geoip, curl
}:

stdenv.mkDerivation rec {
  name = "powerdns-${version}";
  version = "4.0.5";

  src = fetchurl {
    url = "http://downloads.powerdns.com/releases/pdns-${version}.tar.bz2";
    sha256 = "097ci4s2c63gl0bil8yh87dsy0sk3fds4w8cpyjh5kns6zazmj2v";
  };

  buildInputs = [ boost libmysql postgresql lua openldap sqlite protobuf geoip libyamlcpp pkgconfig libsodium curl ];

  # nix destroy with-modules arguments, when using configureFlags
  preConfigure = ''
    configureFlagsArray=(
      "--with-modules=bind gmysql geoip gpgsql gsqlite3 ldap lua pipe random remote"
      --with-sqlite3
      --with-socketdir=/var/lib/powerdns
      --enable-libsodium
      --enable-tools
      --disable-dependency-tracking
      --disable-silent-rules
      --enable-reproducible
      --enable-unit-tests
    )
  '';
  checkPhase = "make check";

  meta = with stdenv.lib; {
    description = "Authoritative DNS server";
    homepage = https://www.powerdns.com;
    platforms = platforms.linux;
    # cannot find postgresql libs on macos x
    license = licenses.gpl2;
    maintainers = [ maintainers.mic92 ];
  };
}
