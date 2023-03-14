{ lib, stdenv, fetchurl, curl, libiconv }:

stdenv.mkDerivation rec {
  pname = "html-xml-utils";
  version = "8.5";

  src = fetchurl {
    url = "https://www.w3.org/Tools/HTML-XML-utils/${pname}-${version}.tar.gz";
    sha256 = "sha256-8gpGrE7TDQKM14R25fIPXikXqVy3vOfffxfY+z5Peec=";
  };

  buildInputs = [curl libiconv];

  meta = with lib; {
    description = "Utilities for manipulating HTML and XML files";
    homepage = "https://www.w3.org/Tools/HTML-XML-utils/";
    license = licenses.w3c;
    platforms = platforms.all;
  };
}
