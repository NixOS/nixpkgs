{ lib, stdenv, fetchurl
, pkg-config, libxslt, freetype, libpng, libxml2
}:

stdenv.mkDerivation rec {
  pname = "swfmill";
  version = "0.3.3";

  src = fetchurl {
    url = "http://swfmill.org/releases/swfmill-${version}.tar.gz";
    sha256 = "15mcpql448vvgsbxs7wd0vdk1ln6rdcpnif6i2zjm5l4xng55s7r";
  };

  # Fixes build with GCC 6
  env.NIX_CFLAGS_COMPILE = "-std=c++03";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libxslt freetype libpng libxml2 ];

  meta = {
    description = "An xml2swf and swf2xml processor with import functionalities";
    homepage = "http://swfmill.org";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
  };
}
