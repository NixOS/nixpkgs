a :  
let 
  fetchurl = a.fetchurl;

  version = a.lib.attrByPath ["version"] "0.10" a; 
  buildInputs = with a; [
    python pil makeWrapper 
  ];
in
rec {
  src = fetchurl {
    url = "http://prdownloads.sourceforge.net/docutils/docutils-${version}.tar.gz";
    sha256 = "0gk0733w34zibzvi6paqqfbbajzaxajc4z5i5wpxlwv73gk281ip";
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
  
