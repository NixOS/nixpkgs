a :  
let 
  lib = a.lib;
  fetchurl = a.fetchurl;

  version = lib.getAttr ["version"] "" a; 
  buildInputs = with a; [
    
  ];
in
rec {
  src = /* Here a fetchurl expression goes */;

  inherit buildInputs;
  configureFlags = [];

  /* doConfigure should be removed if not needed */
  phaseNames = ["doConfigure" "doMakeInstall"];
      
  name = "${abort "Specify name"}-" + version;
  meta = {
    description = "${abort "Specify description"}";
  };
}
