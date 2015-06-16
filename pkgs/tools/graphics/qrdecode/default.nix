{ stdenv, fetchurl, libpng, opencv }:

stdenv.mkDerivation rec {
  name = "libdecodeqr-${version}";
  version = "0.9.3";

  src = fetchurl {
    url = "mirror://debian/pool/main/libd/libdecodeqr/libdecodeqr_${version}.orig.tar.gz";
    sha256 = "1kmljwx69h7zq6zlp2j19bbpz11px45z1abw03acrxjyzz5f1f13";
  };

  buildInputs = [ libpng opencv ];

  preConfigure = ''
    cd src
    sed -e /LDCONFIG/d -i libdecodeqr/Makefile.in
    sed -e '/#include <cv.h>/a#include <ml.h>' -i libdecodeqr/imagereader.h
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${opencv}/include/opencv"
    export NIX_LDFLAGS="$NIX_LDFLAGS -lcxcore"
  '';

  preInstall = "mkdir -p $out/bin $out/lib $out/include $out/share";
  postInstall = "cp sample/simple/simpletest $out/bin/qrdecode";

  meta = {
    description = "QR code decoder library";
    broken = true;
  };
}
