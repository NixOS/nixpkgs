args @ {stdenv, fetchurl, userModeLinux ? false, ...}:

assert !userModeLinux;

import ./generic.nix (

  rec {
    version = "2.6.27.31";
  
    src = fetchurl {
      url = "mirror://kernel/linux/kernel/v2.6/linux-${version}.tar.bz2";
      sha256 = "0ka4x1r3x4r5mngl3xmmplrddj06lrydglcrj3mdinava5g97h6v";
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
