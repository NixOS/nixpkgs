a :  
let 
  fetchurl = a.fetchurl;

  version = a.lib.getAttr ["version"] "0.5" a; 
  buildInputs = with a; [
    python pil makeWrapper 
  ];
in
rec {
  src = fetchurl {
    url = "http://prdownloads.sourceforge.net/docutils/docutils-${version}.tar.gz";
    sha256 = "03k1dakb5j1xi1xd62vqqy7dkgd1fhr4ahmvvmd5g87wxn2gjz3l";
  };

  inherit buildInputs;
  configureFlags = [];

  /* doConfigure should be removed if not needed */
  phaseNames = ["installPythonPackage" "wrapBinContentsPython"];
      
  name = "python-docutils-" + version;
  meta = {
    description = "Processor of ReStructured Text";
  };
}
  
