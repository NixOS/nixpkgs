{ stdenv, fetchurl, curl, libiconv }:

stdenv.mkDerivation rec {
  name = "html-xml-utils-${version}";
  version = "7.1";

  src = fetchurl {
    url = "http://www.w3.org/Tools/HTML-XML-utils/${name}.tar.gz";
    sha256 = "0vnmcrbnc7irrszx5h71s3mqlp9wqh19zig519zbnr5qccigs3pc";
  };

  buildInputs = [curl libiconv];

  meta = with stdenv.lib; {
    description = "Utilities for manipulating HTML and XML files";
    homepage = http://www.w3.org/Tools/HTML-XML-utils/;
    license = licenses.w3c;
    platforms = platforms.all;
  };
}
