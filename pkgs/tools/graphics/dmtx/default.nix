args :  
let 
  lib = args.lib;
  fetchurl = args.fetchurl;

  version = lib.getAttr ["version"] "0.5.2" args; 
  buildInputs = with args; [
    libpng libtiff
  ];
in
rec {
  src = fetchurl {
    url = "http://prdownloads.sourceforge.net/libdmtx/libdmtx-${version}.tar.bz2";
    sha256 = "1xx61gykmq07m2vkqazns5whj8rv9nhwhjs6dakz9ai4qh7d53qz";
  };

  inherit buildInputs;
  configureFlags = [];

  /* doConfigure should be specified separately */
  phaseNames = ["doConfigure" "doMakeInstall"];
      
  name = "dmtx-" + version;
  meta = {
    description = "DataMatrix (2D bar code) processing tools.";
  };
}
