{stdenv, fetchurl, SDL}:

stdenv.mkDerivation { 
  name = "dosbox-0.63";
  src = fetchurl {
    url = http://surfnet.dl.sourceforge.net/sourceforge/dosbox/dosbox-0.63.tar.gz;
    md5 = "629413e41224ae9cdd115fdafd55cbdc";
  };
  buildInputs = [SDL];
}
