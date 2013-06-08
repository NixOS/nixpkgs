{ stdenv, fetchurl
, pkgconfig, libxslt, freetype, libpng, libxml2
}:

stdenv.mkDerivation rec {
  name = "swfmill-0.3.2";

  src = fetchurl {
    url = "http://swfmill.org/releases/${name}.tar.gz";
    sha256 = "077agf62q0xz95dxj4cq9avcqwin94vldrpb80iqwjskvkwpz9gy";
  };

  buildInputs = [ pkgconfig libxslt freetype libpng libxml2 ];

  meta = {
    description = "An xml2swf and swf2xml processor with import functionalities";
    homepage = "http://swfmill.org";
    license = "GPLv2";
  };
}

