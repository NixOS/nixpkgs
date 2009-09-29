args : with args; 
rec {
  src = fetchurl {
    url = http://downloads.sourceforge.net/jfsrec/jfsrec-svn-7.tar.gz;
    sha256 = "163z6ljr05vw2k5mj4fim2nlg4khjyibrii95370pvn474mg28vg";
  };

  buildInputs = [boost];
  configureFlags = [];

  doFixInc = fullDepEntry (''
    sed -e '/[#]include [<]config.h[>]/a\#include <string.h>' -i src/unicode_to_utf8.cpp
    cat src/unicode_to_utf8.cpp
  '') ["minInit" "doUnpack"];

  /* doConfigure should be specified separately */
  phaseNames = ["doFixInc" "doConfigure" "doMakeInstall"];
      
  name = "jfsrec-" + version;
  meta = {
    description = "JFS recovery tool";
  };
}
