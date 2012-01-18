a @ {libpng, bison, flex, fullDepEntry, ...} :  
let 
  s = import ./src-for-default.nix;
  buildInputs = with a; [
    libpng bison flex
  ];
in
rec {
  src = a.fetchUrlFromSrcInfo s;

  inherit (s) name;
  inherit buildInputs;
  configureFlags = [];

  /* doConfigure should be removed if not needed */
  phaseNames = ["doMake" "copyFiles"];

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
