{ stdenv, fetchurl, curl, libiconv }:

stdenv.mkDerivation rec {
  pname = "html-xml-utils";
  version = "7.9";

  src = fetchurl {
    url = "https://www.w3.org/Tools/HTML-XML-utils/${pname}-${version}.tar.gz";
    sha256 = "0gs3xvdbzhk5k12i95p5d4fgkkaldnlv45sch7pnncb0lrpcjsnq";
  };

  buildInputs = [curl libiconv];

  meta = with stdenv.lib; {
    description = "Utilities for manipulating HTML and XML files";
    homepage = "http://www.w3.org/Tools/HTML-XML-utils/";
    license = licenses.w3c;
    platforms = platforms.all;
  };
}
