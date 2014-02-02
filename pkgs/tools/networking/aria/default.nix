
args : with args; 
let version="1.18.3"; in
rec {
  src = /* Here a fetchurl expression goes */
  fetchurl {
    url = "mirror://sourceforge/aria2/stable/aria2-${version}.tar.bz2";
    sha256 = "0y5wv7llq5sdwrsxqkc67wzk8gpb1kl4l1c0zl6l7kr0bkidna9r";
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
