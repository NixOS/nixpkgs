{ stdenv, fetchurl, cmake, python3
, bison, openssl, readline, bzip2
}:

stdenv.mkDerivation rec {
  pname = "monetdb";
  version = "11.39.5";

  src = fetchurl {
    url = "https://dev.monetdb.org/downloads/sources/archive/MonetDB-${version}.tar.bz2";
    sha256 = "1hdlab2gcj71yw6sb3yvl8s027blcsyvch3n5sgi0a2yz84wj765";
  };

  postPatch = ''
    substituteInPlace cmake/monetdb-packages.cmake --replace \
      'get_os_release_info(LINUX_DISTRO LINUX_DISTRO_VERSION)' \
      'set(LINUX_DISTRO "nixos")'
  '';

  nativeBuildInputs = [ cmake python3 ];
  buildInputs = [ bison openssl readline bzip2 ];

  meta = with stdenv.lib; {
    description = "An open source database system";
    homepage = "https://www.monetdb.org/";
    license = licenses.mpl20;
    platforms = platforms.unix;
    maintainers = [ maintainers.StillerHarpo ];
  };
}
