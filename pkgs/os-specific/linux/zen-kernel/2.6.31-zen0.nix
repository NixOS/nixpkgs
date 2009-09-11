a :  
let 
  s = import ./src-for-2.6.31-zen0.nix;
in 
(import ../kernel/generic.nix) (rec {
  inherit (a) stdenv fetchurl perl mktemp module_init_tools;

  src = a.builderDefs.fetchGitFromSrcInfo s;
  version = "2.6.31-zen0";
  config = "./kernel-config";
  features = {
    iwlwifi = true;
    zen = true;
  };

  extraMeta = {
    maintainers = [
      a.lib.maintainers.raskin
    ];
    platforms = with a.lib.platforms; 
      linux;
  };

  preConfigure = '' 
    make allmodconfig

    cp .config ${config}
  '';
})
