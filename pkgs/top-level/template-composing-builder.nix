args : with args; 
rec {
  src = /* Here a fetchurl expression goes */;

  buildInputs = [];
  configureFlags = [];

  /* doConfigure should be specified separately */
  phaseNames = ["doMakeInstall"];
      
  name = "${abort "Specify name"}" + version;
  meta = {
    description = "${abort "Specify description"}";
  };
}
