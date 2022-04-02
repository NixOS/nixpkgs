{ lib, stdenv, fetchurl, curl, libiconv }:

stdenv.mkDerivation rec {
  pname = "html-xml-utils";
  version = "8.3";

  src = fetchurl {
    url = "https://www.w3.org/Tools/HTML-XML-utils/${pname}-${version}.tar.gz";
    sha256 = "sha256-pQxNFtrWYK1nku9TvHfvqdVyl5diN3Gj/OUtjiPT0Iw=";
  };

  buildInputs = [curl libiconv];

  meta = with lib; {
    description = "Utilities for manipulating HTML and XML files";
    homepage = "http://www.w3.org/Tools/HTML-XML-utils/";
    license = licenses.w3c;
    platforms = platforms.all;
  };
}
