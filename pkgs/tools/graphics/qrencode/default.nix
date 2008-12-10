args :  
let 
  lib = args.lib;
  fetchurl = args.fetchurl;

  version = lib.getAttr ["version"] "3.0.3" args; 
  buildInputs = with args; [
    libpng pkgconfig
  ];
in
rec {
  src = fetchurl {
    url = "http://megaui.net/fukuchi/works/qrencode/qrencode-${version}.tar.gz";
    sha256 = "1f5nnbk016casqfprdli50ssv08l0gj5zrd0q4rdvzfwqy67i7vm";
  };

  inherit buildInputs;
  configureFlags = [];

  /* doConfigure should be specified separately */
  phaseNames = ["doConfigure" "doMakeInstall"];
      
  name = "qrencode-" + version;
  meta = {
    description = "QR code encoder";
  };
}
