{ stdenv, fetchurl
, pkgconfig, libxslt, freetype, libpng, libxml2
}:

stdenv.mkDerivation rec {
  name = "swfmill-0.3.3";

  src = fetchurl {
    url = "http://swfmill.org/releases/${name}.tar.gz";
    sha256 = "15mcpql448vvgsbxs7wd0vdk1ln6rdcpnif6i2zjm5l4xng55s7r";
  };

  buildInputs = [ pkgconfig libxslt freetype libpng libxml2 ];

  meta = {
    description = "An xml2swf and swf2xml processor with import functionalities";
    homepage = http://swfmill.org;
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
  };
}
