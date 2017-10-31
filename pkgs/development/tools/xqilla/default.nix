{ stdenv, fetchurl, xercesc }:

stdenv.mkDerivation rec {
  name    = "xqilla-${version}";
  version = "2.3.3";

  src = fetchurl {
    url    = "mirror://sourceforge/xqilla/XQilla-${version}.tar.gz";
    sha256 = "1mjgcyar3qyizpnb0h9lxaj6p9yq4vj09qd8qan1bwv6z6sbjxlg";
  };

  configureFlags = [ "--with-xerces=${xercesc}" ];

  meta = with stdenv.lib; {
    description = "XQilla is an XQuery and XPath 2 library and command line utility written in C++, implemented on top of the Xerces-C library.";
    license     = licenses.asl20 ;
    maintainers = with maintainers; [ obadz ];
    platforms   = platforms.all;
  };
}
