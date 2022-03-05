{ lib, stdenv, fetchurl, cmake, python3
, bison, openssl, readline, bzip2
}:

stdenv.mkDerivation rec {
  pname = "monetdb";
  version = "11.43.5";

  src = fetchurl {
    url = "https://dev.monetdb.org/downloads/sources/archive/MonetDB-${version}.tar.bz2";
    sha256 = "sha256-Pgh2gqsZnDEOBs2t7PoRWXZ9hSPcGRL0YL4QSP8dLL8=";
  };

  postPatch = ''
    substituteInPlace cmake/monetdb-packages.cmake --replace \
      'get_os_release_info(LINUX_DISTRO LINUX_DISTRO_VERSION)' \
      'set(LINUX_DISTRO "nixos")'
  '';

  postInstall = ''
    rm $out/bin/monetdb_mtest.sh
  '';

  nativeBuildInputs = [ cmake python3 ];
  buildInputs = [ bison openssl readline bzip2 ];

  meta = with lib; {
    description = "An open source database system";
    homepage = "https://www.monetdb.org/";
    license = licenses.mpl20;
    platforms = platforms.unix;
    maintainers = [ maintainers.StillerHarpo ];
  };
}
