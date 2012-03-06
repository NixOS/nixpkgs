a :  
let 
  fetchurl = a.fetchurl;

  version = a.lib.attrByPath ["version"] "0.5.0rc1" a; 
  buildInputs = with a; [
    python setuptools
  ];
in
rec {
  src = fetchurl {
    url = "http://prdownloads.sourceforge.net/sourceforge/xmpppy/xmpppy-${version}.tar.gz";
    sha256 = "16hbh8kwc5n4qw2rz1mrs8q17rh1zq9cdl05b1nc404n7idh56si";
  };

  inherit buildInputs;
  configureFlags = [];

  /* doConfigure should be removed if not needed */
  phaseNames = ["mkDirs" "installPythonPackage"];
  mkDirs = a.fullDepEntry(''
    mkdir -p $out/bin $out/lib $out/share $(toPythonPath $out)
    export PYTHONPATH=$PYTHONPATH:$(toPythonPath $out)
  '') ["defEnsureDir" "addInputs"];
      
  name = "xmpp.py-" + version;
  meta = {
    description = "XMPP python library";
  };
}
