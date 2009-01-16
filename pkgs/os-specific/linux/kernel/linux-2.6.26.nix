args @ {stdenv, fetchurl, userModeLinux ? false, ...}:

assert !userModeLinux;

import ./generic.nix (

  rec {
    version = "2.6.26.8";
  
    src = fetchurl {
      url = "mirror://kernel/linux/kernel/v2.6/linux-${version}.tar.bz2";
      sha256 = "1jcdg3r7szrk010px7acwi98xhaj00hblv132sllpg89i8vr2aag";
    };

    features = {
      iwlwifi = true;
    };
 
    config =
      if stdenv.system == "i686-linux" then ./config-2.6.26-i686-smp else
      if stdenv.system == "x86_64-linux" then ./config-2.6.26-x86_64-smp else
      abort "No kernel configuration for your platform!";
  }

  // args
)
