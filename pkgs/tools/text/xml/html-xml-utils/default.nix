{ lib, stdenv, fetchurl, curl, libiconv }:

stdenv.mkDerivation rec {
  pname = "html-xml-utils";
  version = "8.4";

  src = fetchurl {
    url = "https://www.w3.org/Tools/HTML-XML-utils/${pname}-${version}.tar.gz";
    sha256 = "sha256-QbubFOH0zWEC4/jft55xRqJMCWk4aYcxZcQhdppX0Tc=";
  };

  buildInputs = [curl libiconv];

  meta = with lib; {
    description = "Utilities for manipulating HTML and XML files";
    homepage = "http://www.w3.org/Tools/HTML-XML-utils/";
    license = licenses.w3c;
    platforms = platforms.all;
  };
}
