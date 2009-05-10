args : with args; 
rec {
  src = fetchurl {
    url = http://downloads.sourceforge.net/xxdiff/xxdiff-3.2.tar.bz2;
    sha256 = "1f5j9l9n5j2ab0h3iwaz0mnz0y8h7ilc0dbcrfmaibk2njx38mcn";
  };

  buildInputs = [qt flex bison python pkgconfig makeWrapper 
    libX11 libXext];
  configureFlags = [];

  /* doConfigure should be specified separately */
  phaseNames = ["prepareMainBuild" "fixInc"
    "deploy"
    "installPythonPackage" 
    (makeManyWrappers 
      ''$out/bin/*'' 
      ''--prefix PYTHONPATH : $(toPythonPath $out):$PYTHONPATH'')
  ];

  prepareMainBuild = FullDepEntry (''
    cd src 
    export QTDIR=${qt}/
    make -f Makefile.bootstrap makefile
  '') ["minInit" "doUnpack"];

  fixInc = FullDepEntry(''
    sed -e '1i\#include <stdlib.h>' -i resources.inline.h
  '') ["minInit" "doUnpack"];

  deploy = FullDepEntry (''
    ensureDir $out/bin/
    cp ../bin/xxdiff $out/bin
    cd ..
  '') ["minInit" "doMake" "defEnsureDir" "addInputs"];
      
  name = "xxdiff-" + version;
  meta = {
    description = "Interactive merge tool";
  };
}
