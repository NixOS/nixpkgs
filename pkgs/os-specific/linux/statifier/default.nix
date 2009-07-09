a :  
let 
  fetchurl = a.fetchurl;

  version = a.lib.attrByPath ["version"] "1.6.15" a; 
  buildInputs = with a; [
    
  ];
in
rec {
  src = fetchurl {
    url = "http://sourceforge.net/projects/statifier/files/statifier/statifier-${version}.tar.gz";
    sha256 = "0lhdbp7hc15nn6r31yxx7i993a5k8926n5r6j2gi2vvkmf1hciqf";
  };

  inherit buildInputs;
  configureFlags = [];

  /* doConfigure should be removed if not needed */
  phaseNames = ["fixPaths" "doMakeInstall"];

  fixPaths = a.fullDepEntry (''
    sed -e s@/usr/@"$out/"@g -i */Makefile src/statifier
    sed -e s@/bin/bash@"$shell"@g -i src/*.sh
  '') ["minInit" "doUnpack"];
      
  name = "statifier-" + version;
  meta = {
    description = "Tool for creating static Linux binaries";
  };
}
