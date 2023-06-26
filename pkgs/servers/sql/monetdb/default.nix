{ lib, stdenv, fetchurl, cmake, python3, bison, openssl, readline, bzip2 }:

stdenv.mkDerivation rec {
  pname = "monetdb";
  version = "11.45.17";

  src = fetchurl {
    url = "https://dev.monetdb.org/downloads/sources/archive/MonetDB-${version}.tar.bz2";
    sha256 = "sha256-sVRNnaklw2mHkTz8Kw6x8uPfdN+I1n1tOjHBslyMpGc=";
  };

  postPatch = ''
    substituteInPlace cmake/monetdb-packages.cmake --replace \
      'get_os_release_info(LINUX_DISTRO LINUX_DISTRO_VERSION)' \
      'set(LINUX_DISTRO "nixos")'
  '';

  postInstall = ''
    rm $out/bin/monetdb_mtest.sh \
      $out/bin/mktest.py \
      $out/bin/sqlsample.php \
      $out/bin/sqllogictest.py \
      $out/bin/Mz.py \
      $out/bin/Mtest.py \
      $out/bin/sqlsample.pl \
      $out/bin/malsample.pl \
      $out/bin/Mconvert.py
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
