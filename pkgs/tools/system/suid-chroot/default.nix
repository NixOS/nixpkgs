a :  
let 
  fetchurl = a.fetchurl;

  version = a.lib.attrByPath ["version"] "1.0.1" a; 
  buildInputs = with a; [
    
  ];
in
rec {
  src = fetchurl {
    url = "http://myweb.tiscali.co.uk/scottrix/linux/download/suid-chroot-${version}.tar.bz2";
    sha256 = "15gs09md4lyym47ipzffm1ws8jkg028x0cgwxxs9qkdqbl5zb777";
  };

  inherit buildInputs;
  configureFlags = [];

  /* doConfigure should be removed if not needed */
  phaseNames = ["replacePaths" "doMakeInstall"];

  installFlags = "PREFIX=$out";

  replacePaths = a.fullDepEntry (''
    sed -e "s@/usr/@$out/@g" -i Makefile
  '') ["minInit" "doUnpack"];
      
  name = "suid-chroot-" + version;
  meta = {
    description = "Setuid-safe wrapper for chroot";
    maintainers = [
    ];
  };
}
