args @ {stdenv, fetchurl, userModeLinux ? false, ...}:

assert !userModeLinux;

import ./generic.nix (

  rec {
    version = "2.6.27.10";
  
    src = fetchurl {
      url = "mirror://kernel/linux/kernel/v2.6/linux-${version}.tar.bz2";
      sha256 = "1g6k7m75cqjznibl249g43plkrgmca96sq5c7bdp18rmnalwh9w5";
    };

    features = {
      iwlwifi = true;
    };
 
    config =
      if stdenv.system == "i686-linux" then ./config-2.6.27-i686-smp else
      if stdenv.system == "x86_64-linux" then ./config-2.6.27-x86_64-smp else
      abort "No kernel configuration for your platform!";
  }

  // args
)
