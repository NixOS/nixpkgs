{ stdenv, fetchurl, clang, which, libobjc2 }:
let
  version = "2.6.6";
in
stdenv.mkDerivation rec {
  name = "gnustep-make-${version}";
  src = fetchurl {
    url = "ftp://ftp.gnustep.org/pub/gnustep/core/gnustep-make-2.6.6.tar.gz";
    sha256 = "07cqr8x17bia9w6clbmiv7ay6r9nplrjz2cyzinv4w7zfpc19vxw";
  };
  configureFlags = "--with-layout=fhs-system";
  buildInputs = [ clang which libobjc2 ];
  meta = {
    description = "GNUstep-make is a build manager for GNUstep.";

    homepage = http://gnustep.org/;

    license = stdenv.lib.licenses.lgpl2Plus;

    maintainers = with stdenv.lib.maintainers; [ ashalkhakov ];
    platforms = stdenv.lib.platforms.all;
  };
}
