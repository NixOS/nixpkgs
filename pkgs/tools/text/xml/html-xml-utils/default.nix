{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "html-xml-utils-6.9";

  src = fetchurl {
    url = "http://www.w3.org/Tools/HTML-XML-utils/${name}.tar.gz";

    sha256 = "1cpshwz60h7xsw1rvv84jl4bn9zjqii9hb8zvwm7a0fahkf03x4w";
  };

  meta = {
    description = "Utilities for manipulating HTML and XML files";
    homepage = http://www.w3.org/Tools/HTML-XML-utils/;
    license = stdenv.lib.licenses.w3c;
    platforms = stdenv.lib.platforms.linux;
  };
}
