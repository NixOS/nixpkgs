{ stdenv, fetchurl, curl, libiconv }:

stdenv.mkDerivation rec {
  pname = "html-xml-utils";
  version = "7.7";

  src = fetchurl {
    url = "https://www.w3.org/Tools/HTML-XML-utils/${pname}-${version}.tar.gz";
    sha256 = "1vwqp5q276j8di9zql3kygf31z2frp2c59yjqlrvvwcvccvkcdwr";
  };

  buildInputs = [curl libiconv];

  meta = with stdenv.lib; {
    description = "Utilities for manipulating HTML and XML files";
    homepage = http://www.w3.org/Tools/HTML-XML-utils/;
    license = licenses.w3c;
    platforms = platforms.all;
  };
}
