a :  
let 
  fetchurl = a.fetchurl;

  version = a.lib.attrByPath ["version"] "0.6.27" a; 
  buildInputs = with a; [
    perl intltool gettext
  ];
in
rec {
  src = fetchurl {
    url = "http://www.gnokii.org/download/gnokii/gnokii-${version}.tar.bz2";
    sha256 = "11p8iv5jmlah3ls16a3jkndwlvwxxan8vwkwazlihaasfmgxgwb9";
  };

  inherit buildInputs;
  configureFlags = [];

  /* doConfigure should be removed if not needed */
  phaseNames = ["doConfigure" "doMakeInstall"];
      
  name = "gnokii-" + version;
  meta = {
    description = "Cellphone tool";
  };
}
