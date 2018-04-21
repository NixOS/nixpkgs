{ stdenv, fetchurl, curl, libiconv }:

stdenv.mkDerivation rec {
  name = "html-xml-utils-${version}";
  version = "7.6";

  src = fetchurl {
    url = "http://www.w3.org/Tools/HTML-XML-utils/${name}.tar.gz";
    sha256 = "0l97ps089byy62838wf2jwvvc465iw29z9r5kwmwcq7f3bn11y3m";
  };

  buildInputs = [curl libiconv];

  meta = with stdenv.lib; {
    description = "Utilities for manipulating HTML and XML files";
    homepage = http://www.w3.org/Tools/HTML-XML-utils/;
    license = licenses.w3c;
    platforms = platforms.all;
  };
}
