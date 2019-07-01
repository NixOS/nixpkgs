{ stdenv, fetchurl, pkgconfig, fetchpatch
, boost, libyamlcpp, libsodium, sqlite, protobuf, botan2, libressl
, mysql57, postgresql, lua, openldap, geoip, curl, opendbx, unixODBC
}:

stdenv.mkDerivation rec {
  name = "powerdns-${version}";
  version = "4.1.7";

  src = fetchurl {
    url = "https://downloads.powerdns.com/releases/pdns-${version}.tar.bz2";
    sha256 = "11c4r0mbq6ybbihm0jbl9hspb01pj1gi6x3m374liw9jij7dw8b4";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2019-10162-4.1.8-invalidrecords.patch";
      url = "https://sources.debian.org/data/main/p/pdns/4.1.6-3/debian/patches/CVE-2019-10162-4.1.8-invalidrecords.patch";
      sha256 = "0960351p20fm0vjd0k5p7bcf2kvnikkzbxzp2wm8bwhcx12jlyll";
    })
    (fetchpatch {
      name = "CVE-2019-10163-4.1.8-busyloop.patch";
      url = "https://sources.debian.org/data/main/p/pdns/4.1.6-3/debian/patches/CVE-2019-10163-4.1.8-busyloop.patch";
      sha256 = "0z12frdki1vidskiyin0m6jza88p7535igyj712s5sq8rw5xxz6x";
    })
  ];

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
