
args : with args; 
let version="0.14.0"; in
rec {
  src = /* Here a fetchurl expression goes */
  fetchurl {
    url = "mirror://sourceforge/aria2/aria2c-${version}.tar.bz2";
    sha256 = "0d6vpy7f4228byahsg4dlhalfkbscx941klhdlxd0y5c3mxxwkfr";
  };

  buildInputs = [];
  configureFlags = [];

  /* doConfigure should be specified separately */
  phaseNames = ["doConfigure" "doMakeInstall"];
      
  name = "aria-" + version;
  meta = {
    description = "Multiprotocol download manager";
  };
}
