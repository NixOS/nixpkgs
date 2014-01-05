a :  
let 
  fetchurl = a.fetchurl;

  version = a.lib.attrByPath ["version"] "0.11" a;
  buildInputs = with a; [
    python pil makeWrapper
  ];
in
rec {
  src = fetchurl {
    url = "http://prdownloads.sourceforge.net/docutils/docutils-${version}.tar.gz";
    sha256 = "1jbybs5a396nrjy9m13pgvsxdwaj7jw7nsawkhl4fi1nvxm1dx4s";
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
  
