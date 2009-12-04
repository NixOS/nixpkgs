{ stdenv, fetchurl, boost }:

stdenv.mkDerivation {
  name = "jfsrec-pre-svn-7";
  
  src = fetchurl {
    url = http://downloads.sourceforge.net/jfsrec/jfsrec-svn-7.tar.gz;
    sha256 = "163z6ljr05vw2k5mj4fim2nlg4khjyibrii95370pvn474mg28vg";
  };

  buildInputs = [ boost ];

  preConfigure =
    ''
      sed -e '/[#]include [<]config.h[>]/a\#include <string.h>' -i src/unicode_to_utf8.cpp
      cat src/unicode_to_utf8.cpp
    '';

  meta = {
    description = "JFS recovery tool";
  };
}
