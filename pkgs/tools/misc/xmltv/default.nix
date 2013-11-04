{ fetchurl, perl, perlPackages }:

import ../../../development/perl-modules/generic perl {
  name = "xmltv-0.5.51";
  src = fetchurl {
    url = mirror://sourceforge/xmltv/xmltv-0.5.51.tar.bz2;
    sha256 = "0vgc167y6y847m18vg3qwjy3df12bryjy9par01n5b9mjalx9jpd";
  };
  #makeMakerFlags = "-components tv_grab_nl";
  buildInputs = [
    perlPackages.TermReadKey perlPackages.XMLTwig perlPackages.XMLWriter
    perlPackages.DateManip perlPackages.HTMLTree perlPackages.HTMLParser
    perlPackages.HTMLTagset perlPackages.URI perlPackages.LWP
  ];
  meta.broken = true;
}
