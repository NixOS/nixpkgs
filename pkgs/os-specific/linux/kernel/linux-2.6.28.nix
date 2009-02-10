args @ {stdenv, fetchurl, userModeLinux ? false, ...}:

assert !userModeLinux;

import ./generic.nix (

  rec {
    version = "2.6.28.4";
  
    src = fetchurl {
      url = "mirror://kernel/linux/kernel/v2.6/linux-${version}.tar.bz2";
      sha256 = "1k45azdjv4i9hh76nbi442vsfpwz31736aq3la2pn5avmkwiz2mm";
    };

    features = {
      iwlwifi = true;
    };
 
    config =
      if stdenv.system == "i686-linux" then ./config-2.6.28-i686-smp else
      if stdenv.system == "x86_64-linux" then ./config-2.6.28-x86_64-smp else
      abort "No kernel configuration for your platform!";
  }

  // args
)
