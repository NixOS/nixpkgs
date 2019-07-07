{ stdenv, fetchurl, xercesc }:

stdenv.mkDerivation rec {
  name    = "xqilla-${version}";
  version = "2.3.4";

  src = fetchurl {
    url    = "mirror://sourceforge/xqilla/XQilla-${version}.tar.gz";
    sha256 = "0m9z7diw7pdyb4qycbqyr2x55s13v8310xsi7yz0inpw27q4vzdd";
  };

  configureFlags = [ "--with-xerces=${xercesc}" ];

  meta = with stdenv.lib; {
    description = "XQilla is an XQuery and XPath 2 library and command line utility written in C++, implemented on top of the Xerces-C library.";
    license     = licenses.asl20 ;
    maintainers = with maintainers; [ obadz ];
    platforms   = platforms.all;
  };
}
