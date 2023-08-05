{ lib, stdenv, fetchurl
, pkg-config, libxslt, freetype, libpng, libxml2
}:

stdenv.mkDerivation rec {
  pname = "swfmill";
  version = "0.3.6";

  src = fetchurl {
    url = "http://swfmill.org/releases/swfmill-${version}.tar.gz";
    sha256 = "sha256-2yT2OWOVf67AK7FLi2HNr3CWd0+M/eudNXPi4ZIxVI4=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libxslt freetype libpng libxml2 ];

  meta = {
    description = "An xml2swf and swf2xml processor with import functionalities";
    homepage = "http://swfmill.org";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
  };
}
