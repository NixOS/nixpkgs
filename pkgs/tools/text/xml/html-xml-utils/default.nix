{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "html-xml-utils-6.4";

  src = fetchurl {
    url = "http://www.w3.org/Tools/HTML-XML-utils/${name}.tar.gz";

    sha256 = "0dqa8vjk5my728hmb7dhl6nbg7946fh905j0yzlwx7p7rg2zrxcp";
  };

  patches = [ ./no-Boolean-type.patch ];

  meta = {
    description = "Utilities for manipulating HTML and XML files";
    homepage = http://www.w3.org/Tools/HTML-XML-utils/;
    license = "free-non-copyleft"; #TODO W3C
  };
}
