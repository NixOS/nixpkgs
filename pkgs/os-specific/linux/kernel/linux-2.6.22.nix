args @ {stdenv, fetchurl, userModeLinux ? false, ...}:

import ./generic.nix (

  rec {
    version = "2.6.22.19";
  
    src = fetchurl {
      url = "mirror://kernel/linux/kernel/v2.6/linux-${version}.tar.bz2";
      sha256 = "0jwax5aqfmdfg5pa40zx94x7n5ykr8m5rqczb1m5mc8j98hvnycq";
    };

    config =
      if userModeLinux then ./config-2.6.22-uml else
      if stdenv.system == "i686-linux" then ./config-2.6.22-i686-smp else
      if stdenv.system == "x86_64-linux" then ./config-2.6.22-x86_64-smp else
      abort "No kernel configuration for your platform!";
  }

  // args
)
