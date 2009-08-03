args @ {stdenv, fetchurl, userModeLinux ? false, oldI686 ? false, ...}:

assert !userModeLinux;

import ./generic.nix (

  let
    baseVersion = "2.6.30"; 
  in

  rec {
    version = "2.6.31-rc3";
  
    src = fetchurl {
      url = "mirror://kernel/linux/kernel/v2.6/linux-${baseVersion}.tar.bz2";
      sha256 = "d7b9f19b92fd5c693c16cd62f441d051b699f28ec6a175d1b464e58bacd8c78f";
    };

    features = {
      iwlwifi = true;
    };
 
    config =
      if stdenv.system == "i686-linux" then if oldI686 then ./config-2.6.31-rc4-all-mod-i686-older else 
        ./config-2.6.31-rc3-all-mod-i686 else
      if stdenv.system == "x86_64-linux" then ./config-2.6.31-rc3-all-mod-amd64 else
      abort "No kernel configuration for your platform!";
  }

  // args
)
