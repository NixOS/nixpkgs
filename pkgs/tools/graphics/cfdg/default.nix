a @ {libpng, bison, flex, ffmpeg, fullDepEntry, ...} :  
let 
  s = import ./src-for-default.nix;
  buildInputs = with a; [
    libpng bison flex ffmpeg
  ];
in
rec {
  src = a.fetchUrlFromSrcInfo s;

  inherit (s) name;
  inherit buildInputs;
  configureFlags = [];

  /* doConfigure should be removed if not needed */
  phaseNames = ["doFixInc" "doMake" "copyFiles"];
 
  doFixInc = a.fullDepEntry ''
    sed -e "/YY_NO_UNISTD/a#include <stdio.h>" -i src-common/cfdg.l
  '' ["doUnpack" "minInit"];
 
  copyFiles = a.fullDepEntry ''
    mkdir -p $out/bin
    cp cfdg $out/bin/

    mkdir -p $out/share/doc/${name}
    cp *.txt $out/share/doc/${name}
  '' ["defEnsureDir" "doMake"];
      
  meta = {
    description = "Context-free design grammar - a tool for graphics generation";
    maintainers = [
      a.lib.maintainers.raskin
    ];
    platforms = with a.lib.platforms; 
      linux;
  };
}
