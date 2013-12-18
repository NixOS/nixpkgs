
args : with args; 
let version="0.16.2"; in
rec {
  src = /* Here a fetchurl expression goes */
  fetchurl {
    url = "mirror://sourceforge/aria2/aria2c-${version}.tar.bz2";
    sha256 = "02qj3j7a1r477pmk969nd3aa93m33kh4101azy001i9jacpjvzrp";
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
