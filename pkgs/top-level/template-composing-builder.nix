args :  
let 
  lib = args.lib;
  fetchurl = args.fetchurl;

  version = lib.getAttr ["version"] "" args; 
  buildInputs = with args; [
    
  ];
in
rec {
  src = /* Here a fetchurl expression goes */;

  inherit buildInputs;
  configureFlags = [];

  /* doConfigure should be specified separately */
  phaseNames = ["doMakeInstall"];
      
  name = "${abort "Specify name"}-" + version;
  meta = {
    description = "${abort "Specify description"}";
  };
}
