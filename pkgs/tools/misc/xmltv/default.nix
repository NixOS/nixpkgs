{ fetchurl, perl, perlTermReadKey, perlXMLTwig, perlXMLWriter
, perlDateManip, perlHTMLTree, perlHTMLParser, perlHTMLTagset
, perlURI, perlLWP
}:

import ../../../development/perl-modules/generic perl {
  name = "xmltv-0.5.45";
  src = fetchurl {
    url = mirror://sourceforge/xmltv/xmltv-0.5.45.tar.bz2;
    sha256 = "0w6yy4r41c0pr1yvz017dkqj3526jiq9gza0jzw8ygk04jdh6ji3";
  };
  makeMakerFlags = "-components tv_grab_nl";
  buildInputs = [
    perlTermReadKey perlXMLTwig perlXMLWriter perlDateManip
    perlHTMLTree perlHTMLParser perlHTMLTagset perlURI perlLWP
  ];
}
