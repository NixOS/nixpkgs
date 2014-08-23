{ stdenv, fetchurl, boost }:

stdenv.mkDerivation {
  name = "jfsrec-0-pre-svn-7";

  src = fetchurl {
    url = mirror://sourceforge/jfsrec/jfsrec-svn-7.tar.gz;
    sha256 = "163z6ljr05vw2k5mj4fim2nlg4khjyibrii95370pvn474mg28vg";
  };

  patches = [ ./jfsrec-gcc-4.3.patch ];
  buildInputs = [ boost ];

  preConfigure =
    ''
      sed -e '/[#]include [<]config.h[>]/a\#include <string.h>' -i src/unicode_to_utf8.cpp
    '';

  meta = {
    description = "JFS recovery tool";
    homepage = http://jfsrec.sourceforge.net/;
  };
}
