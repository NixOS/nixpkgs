a :  
let 
  fetchurl = a.fetchurl;

  version = a.lib.attrByPath ["version"] "1.04" a; 
  buildInputs = with a; [
    
  ];
in
rec {
  src = fetchurl {
    url = "http://www.jwz.org/dadadodo/dadadodo-${version}.tar.gz";
    sha256 = "1pzwp3mim58afjrc92yx65mmgr1c834s1v6z4f4gyihwjn8bn3if";
  };

  inherit buildInputs;
  configureFlags = [];

  /* doConfigure should be removed if not needed */
  phaseNames = ["doMake" "doDeploy"];
  installFlags = "PREFIX=$out";

  doDeploy = a.fullDepEntry (''
    mkdir -p $out/bin
    cp dadadodo $out/bin
  '') [ "minInit" "doMake" "defEnsureDir"];
      
  name = "dadadodo-" + version;
  meta = {
    description = "Markov chain-based text generator";
  };
}
