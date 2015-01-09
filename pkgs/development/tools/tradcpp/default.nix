{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "tradcpp-0.4";

  src = fetchurl {
    url = http://ftp.netbsd.org/pub/NetBSD/misc/dholland/tradcpp-0.4.tar.gz;
    sha256 = "c60aa356945e0b6634bd449ead6a4fca0059d2ce3ae8044cf982140bbd54e688";
  };

  # tradcpp only comes with BSD-make Makefile; the patch adds configure support
  patches = [ ./tradcpp-configure.patch ];
  postPatch = "chmod +x configure";

  meta = {
    description = "A traditional (K&R-style) C macro preprocessor";
    platforms = stdenv.lib.platforms.all;
  };

}
