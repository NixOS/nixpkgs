{ stdenv, fetchurl, pkgconfig,
  boost, libyamlcpp, libsodium, sqlite, protobuf,
  libmysql, postgresql, lua, openldap, geoip, curl
}:

stdenv.mkDerivation rec {
  name = "powerdns-${version}";
  version = "4.0.4";

  src = fetchurl {
    url = "http://downloads.powerdns.com/releases/pdns-${version}.tar.bz2";
    sha256 = "0qypns1iqlrc5d3iwabrsi1vpb0yffy36chsb1zpqiv9vs4snx6r";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ boost libmysql postgresql lua openldap sqlite protobuf geoip libyamlcpp libsodium curl ];

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
