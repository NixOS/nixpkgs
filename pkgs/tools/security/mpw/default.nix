{ stdenv, fetchzip, autoconf, automake, openssl, libxml2, fetchFromGitHub, ncurses }:

let
  scrypt_src = fetchzip {
    url = "http://www.tarsnap.com/scrypt/scrypt-1.2.0.tgz";
    sha256 = "0ahylib2pimlhjcm566kpim6n16jci5v749xwdkr9ivgfjrv3xn4";
  };

in stdenv.mkDerivation {
  name = "mpw-2.1-6834f36";

  src = fetchFromGitHub {
    owner = "Lyndir";
    repo = "MasterPassword";
    rev = "6834f3689f5dfd4e59ad6959961d349c224977ee";
    sha256 = "0zlpx3hb1y2l60hg961h05lb9yf3xb5phnyycvazah2674gkwb2p";
  };

  postUnpack = ''
    sourceRoot+=/MasterPassword/C
  '';

  prePatch = ''
    patchShebangs .
    mkdir lib/scrypt/src
    cp -R --no-preserve=ownership ${scrypt_src}/* lib/scrypt/src
    chmod +w -R lib/scrypt/src
    substituteInPlace lib/scrypt/src/libcperciva/cpusupport/Build/cpusupport.sh \
      --replace dirname "$(type -P dirname)"
    substituteInPlace lib/scrypt/src/Makefile.in --replace "command -p mv" "mv"
  '';

  NIX_CFLAGS_COMPILE = "-I${libxml2.dev}/include/libxml2";

  buildInputs = [ autoconf automake openssl libxml2 ncurses ];

  buildPhase = ''
    substituteInPlace build --replace '"curses"' '"ncurses"'
    targets="mpw mpw-tests" ./build
  '';

  installPhase = ''
    mkdir -p $out/bin
    mv mpw $out/bin/mpw
  '';

  meta = {
    platforms = stdenv.lib.platforms.unix;
  };
}
