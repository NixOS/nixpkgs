args @ {stdenv, fetchurl, userModeLinux ? false, ...}:

import ./generic.nix (

  rec {
    version = "2.6.25.20";
  
    src = fetchurl {
      url = "mirror://kernel/linux/kernel/v2.6/linux-${version}.tar.bz2";
      sha256 = "07knyjhvanvclk6xdwi07vfvsmiqciqaj26cn78ayiqqqr9d4f6y";
    };

    features = {
      iwlwifi = true;
    };
 
    config =
      if userModeLinux then ./config-2.6.25-uml else
      if stdenv.system == "i686-linux" then ./config-2.6.25-i686-smp else
      if stdenv.system == "x86_64-linux" then ./config-2.6.25-x86_64-smp else
      abort "No kernel configuration for your platform!";
  }

  // args
)
