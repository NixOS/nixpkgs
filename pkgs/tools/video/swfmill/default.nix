{ lib, stdenv, fetchurl
, pkg-config, libxslt, freetype, libpng, libxml2
}:

stdenv.mkDerivation rec {
  pname = "swfmill";
<<<<<<< HEAD
  version = "0.3.6";

  src = fetchurl {
    url = "http://swfmill.org/releases/swfmill-${version}.tar.gz";
    sha256 = "sha256-2yT2OWOVf67AK7FLi2HNr3CWd0+M/eudNXPi4ZIxVI4=";
  };

=======
  version = "0.3.3";

  src = fetchurl {
    url = "http://swfmill.org/releases/swfmill-${version}.tar.gz";
    sha256 = "15mcpql448vvgsbxs7wd0vdk1ln6rdcpnif6i2zjm5l4xng55s7r";
  };

  # Fixes build with GCC 6
  env.NIX_CFLAGS_COMPILE = "-std=c++03";

  # Remove once updated past 0.3.5
  env.NIX_LDFLAGS = "-lz";

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libxslt freetype libpng libxml2 ];

  meta = {
    description = "An xml2swf and swf2xml processor with import functionalities";
    homepage = "http://swfmill.org";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
  };
}
