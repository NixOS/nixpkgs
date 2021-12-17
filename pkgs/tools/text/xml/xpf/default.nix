{lib, stdenv, fetchurl, python2, libxml2}:

assert libxml2.pythonSupport == true;

stdenv.mkDerivation rec {
  pname = "xpf";
  version = "0.2";

  src = fetchurl {
    url = "http://tarballs.nixos.org/xpf-${version}.tar.gz";
    sha256 = "0ljx91w68rnh4871c0xlq2whlmhqz8dr39wcdczfjjpniqz1fmpz";
  };

  buildInputs = [ python2 libxml2 ];

  meta = {
    description = "XML Pipes and Filters - command line tools for manipulating and querying XML data";
    homepage = "http://www.cs.uu.nl/wiki/bin/view/Martin/XmlPipesAndFilters";
    platforms = lib.platforms.unix;
  };
}
