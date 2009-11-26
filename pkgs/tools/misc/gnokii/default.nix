a :  
let 
  fetchurl = a.fetchurl;

  s = import ./src-for-default.nix; 
  buildInputs = with a; [
    perl intltool gettext libusb
  ];
in
rec {
  src = a.fetchUrlFromSrcInfo s;

  inherit buildInputs;
  configureFlags = [];

  /* doConfigure should be removed if not needed */
  phaseNames = ["doConfigure" "doMakeInstall"];
      
  inherit(s) name;
  meta = {
    description = "Cellphone tool";
    maintainers = [a.lib.maintainers.raskin];
    platforms = with a.lib.platforms; linux;
  };
}
