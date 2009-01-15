args @ {stdenv, fetchurl, userModeLinux ? false, ...}:

import ./generic.nix (

  rec {
    version = "2.6.21.7";
  
    src = fetchurl {
      url = "mirror://kernel/linux/kernel/v2.6/linux-${version}.tar.bz2";
      sha256 = "1c8ndsz35qd8vyng3xsxjjkjv5bnzyvc9b5vd85fz5v0bjp8hx50";
    };

    config =
      if userModeLinux then ./config-2.6.21-uml else
      if stdenv.system == "i686-linux" then ./config-2.6.21-i686-smp else
      if stdenv.system == "x86_64-linux" then ./config-2.6.21-x86_64-smp else
      abort "No kernel configuration for your platform!";
  }

  // args
)
