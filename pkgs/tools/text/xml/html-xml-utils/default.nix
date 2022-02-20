{ lib, stdenv, fetchurl, curl, libiconv }:

stdenv.mkDerivation rec {
  pname = "html-xml-utils";
  version = "8.2";

  src = fetchurl {
    url = "https://www.w3.org/Tools/HTML-XML-utils/${pname}-${version}.tar.gz";
    sha256 = "sha256-ANs8xod8iFv81ACZM859Qn1HIVbyUConyha8rwH6rmQ=";
  };

  buildInputs = [curl libiconv];

  meta = with lib; {
    description = "Utilities for manipulating HTML and XML files";
    homepage = "http://www.w3.org/Tools/HTML-XML-utils/";
    license = licenses.w3c;
    platforms = platforms.all;
  };
}
