{ lib, stdenv, fetchurl, cmake, python3, bison, openssl, readline, bzip2 }:

stdenv.mkDerivation (finalAttrs: {
  pname = "monetdb";
  version = "11.47.17";

  src = fetchurl {
    url = "https://dev.monetdb.org/downloads/sources/archive/MonetDB-${finalAttrs.version}.tar.bz2";
    hash = "sha256-2bMzIlvSShNZMVKzBl5T/T33l0PPcBFH35gJs0qlD4E=";
  };

  nativeBuildInputs = [ bison cmake python3 ];
  buildInputs = [ openssl readline bzip2 ];

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

  meta = with lib; {
    description = "An open source database system";
    homepage = "https://www.monetdb.org/";
    license = licenses.mpl20;
    platforms = platforms.unix;
    maintainers = [ maintainers.StillerHarpo ];
  };
})
