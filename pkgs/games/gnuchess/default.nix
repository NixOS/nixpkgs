a :  
let 
  fetchurl = a.fetchurl;

  version = a.lib.getAttr ["version"] "5.07" a; 
  buildInputs = with a; [
    flex
  ];
in
rec {
  src = fetchurl {
    url = "mirror://gnu/chess/gnuchess-${version}.tar.gz";
    sha256 = "0zh15m35fzbsrk1aann9pwlkv54dwb00snx99pk3xbg5bwkf125k";
  };

  inherit buildInputs;
  configureFlags = [];

  /* doConfigure should be removed if not needed */
  phaseNames = ["doConfigure" "preBuild" "doMakeInstall"];

  preBuild = a.FullDepEntry (''
    sed -i src/input.c -e 's/static pthread_t/pthread_t/'
    sed -i "s@gnuchess@$out/bin/gnuchess@" -i src/gnuchessx
  '') ["minInit" "doUnpack"];
      
  name = "gnuchess-" + version;
  meta = {
    description = "GNU Chess playing program";
  };
}
