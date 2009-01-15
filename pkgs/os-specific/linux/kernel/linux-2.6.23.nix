args @ {stdenv, fetchurl, userModeLinux ? false, ...}:

import ./generic.nix (

  rec {
    version = "2.6.23.17";
  
    src = fetchurl {
      url = "mirror://kernel/linux/kernel/v2.6/linux-${version}.tar.bz2";
      sha256 = "0lww6ywgl353xlaxcc3hg5d2q1vcydbqhddvkfpphr07zr7mwl32";
    };

    config =
      if userModeLinux then ./config-2.6.23-uml else
      if stdenv.system == "i686-linux" then ./config-2.6.23-i686-smp else
      if stdenv.system == "x86_64-linux" then ./config-2.6.23-x86_64-smp else
      abort "No kernel configuration for your platform!";
  }

  // args
)
