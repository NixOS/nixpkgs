{ lib, stdenv, fetchurl, cmake, python3, bison, openssl, readline, bzip2 }:

<<<<<<< HEAD
stdenv.mkDerivation (finalAttrs: {
  pname = "monetdb";
  version = "11.47.5";

  src = fetchurl {
    url = "https://dev.monetdb.org/downloads/sources/archive/MonetDB-${finalAttrs.version}.tar.bz2";
    hash = "sha256-GuGGs3hAheNYsaiUG7femLhi38c4gB528bruRotOdNE=";
  };

  nativeBuildInputs = [ bison cmake python3 ];
  buildInputs = [ openssl readline bzip2 ];

=======
stdenv.mkDerivation rec {
  pname = "monetdb";
  version = "11.45.13";

  src = fetchurl {
    url = "https://dev.monetdb.org/downloads/sources/archive/MonetDB-${version}.tar.bz2";
    sha256 = "sha256-TYTzC1oiU/YwrJNABwyA50qSB12cwrMurqYFVCtSAcc=";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
      $out/bin/malsample.pl \
      $out/bin/Mconvert.py
  '';

=======
      $out/bin/malsample.pl
  '';

  nativeBuildInputs = [ cmake python3 ];
  buildInputs = [ bison openssl readline bzip2 ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "An open source database system";
    homepage = "https://www.monetdb.org/";
    license = licenses.mpl20;
    platforms = platforms.unix;
    maintainers = [ maintainers.StillerHarpo ];
  };
<<<<<<< HEAD
})
=======
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
