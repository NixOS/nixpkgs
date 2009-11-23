args :  
let 
  lib = args.lib;
  fetchurl = args.fetchurl;
  fullDepEntry = args.fullDepEntry;

  version = "11"; 
  buildInputs = with args; [
    unzip
  ];
in
rec {
  src = fetchurl {
    url = "http://prdownloads.sourceforge.net/sourceforge/bmrsa/bmrsa${version}.zip";
    sha256 = "0ksd9xkvm9lkvj4yl5sl0zmydp1wn3xhc55b28gj70gi4k75kcl4";
  };

  inherit buildInputs;
  configureFlags = [];

  /* doConfigure should be specified separately */
  phaseNames = ["doMakeInstall"];

  doUnpack = fullDepEntry (''
    mkdir bmrsa
    cd bmrsa 
    unzip ${src}
    sed -e 's/gcc/g++/' -i Makefile
    ensureDir $out/bin
    echo -e 'install:\n\tcp bmrsa '$out'/bin' >> Makefile
  '') ["minInit" "addInputs" "defEnsureDir"];
      
  name = "bmrsa-"+version;
  meta = {
    description = "RSA utility";
  };
}

