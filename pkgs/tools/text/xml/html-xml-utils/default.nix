{ lib, stdenv, fetchurl, curl, libiconv }:

stdenv.mkDerivation rec {
  pname = "html-xml-utils";
  version = "8.1";

  src = fetchurl {
    url = "https://www.w3.org/Tools/HTML-XML-utils/${pname}-${version}.tar.gz";
    sha256 = "sha256-23SCNQpo0udPbCpuF9hxugbJQQHs4edKNX6nghu0Ges=";
  };

  buildInputs = [curl libiconv];

  meta = with lib; {
    description = "Utilities for manipulating HTML and XML files";
    homepage = "http://www.w3.org/Tools/HTML-XML-utils/";
    license = licenses.w3c;
    platforms = platforms.all;
  };
}
