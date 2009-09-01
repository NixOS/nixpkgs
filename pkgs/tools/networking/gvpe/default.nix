a :  
let 
  s = import ./src-for-default.nix;
  buildInputs = with a; [
    openssl
  ];
in
rec {
  src = a.fetchUrlFromSrcInfo s;

  inherit (s) name;
  inherit buildInputs;
  configureFlags = [];

  /* doConfigure should be removed if not needed */
  phaseNames = ["doConfigure" "doMakeInstall"];
      
  meta = {
    description = "A proteted multinode virtual network";
    maintainers = [
      a.lib.maintainers.raskin
    ];
    platforms = with a.lib.platforms; linux ++ freebsd;
  };
}
