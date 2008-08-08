args : with args; 
let 
  version = lib.getAttr ["version"] "1.12.1" args; 
  sha256 = lib.getAttr ["sha256"] 
    "0xmrp7vkkp1hfblb6nl3rh2651qsbcm21bnncpnma1sf40jaf8wj" args;
  pkgName = "lincity";
in
rec {
  src = fetchurl {
    url = "mirror://sourceforge/lincity/${pkgName}-${version}.tar.gz";
    inherit sha256;
  };

  buildInputs = [libICE libpng libSM libX11 libXext
    xextproto zlib xproto];
  configureFlags = [];

  /* doConfigure should be specified separately */
  phaseNames = ["doConfigure" "doMakeInstall"];
      
  name = "${pkgName}-" + version;
  meta = {
    description = "City simulation game";
  };
}
