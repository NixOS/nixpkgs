{ fetchurl, perl, perlTermReadKey, perlXMLTwig, perlXMLWriter
, perlDateManip, perlHTMLTree, perlHTMLParser, perlHTMLTagset
, perlURI, perlLWP
}:

import ../../../development/perl-modules/generic perl {
  name = "xmltv-0.5.37";
  src = fetchurl {
    url = http://heanet.dl.sourceforge.net/sourceforge/xmltv/xmltv-0.5.37.tar.bz2;
    md5 = "40b7675cc1b7632065ebbd1e0ecf860f";
  };
  makeMakerFlags = "-components tv_grab_nl";
  buildInputs = [
    perlTermReadKey perlXMLTwig perlXMLWriter perlDateManip
    perlHTMLTree perlHTMLParser perlHTMLTagset perlURI perlLWP
  ];
}
