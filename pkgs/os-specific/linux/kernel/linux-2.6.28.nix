args @ {stdenv, fetchurl, userModeLinux ? false, ...}:

assert !userModeLinux;

import ./generic.nix (

  rec {
    version = "2.6.28.10";
  
    src = fetchurl {
      url = "mirror://kernel/linux/kernel/v2.6/linux-${version}.tar.bz2";
      sha256 = "10vryshzpgk7vqmb3f0z981r5nci722kfqbjd274qwjyanxlj60b";
    };

    features = {
      iwlwifi = true;
    };
 
    config =
      if stdenv.system == "i686-linux" then ./config-2.6.28-i686-smp else
      if stdenv.system == "x86_64-linux" then ./config-2.6.28-x86_64-smp else
      if stdenv.system == "armv5tel-linux" then ./config-2.6.28-arm else
      abort "No kernel configuration for your platform!";
  }

  // args
)
