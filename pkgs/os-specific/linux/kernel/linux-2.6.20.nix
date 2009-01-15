args @ {stdenv, fetchurl, userModeLinux ? false, ...}:

import ./generic.nix (

  rec {
    version = "2.6.20.21";
  
    src = fetchurl {
      url = "mirror://kernel/linux/kernel/v2.6/linux-${version}.tar.bz2";
      sha256 = "1ympa2sgnx0sxs30g42zlkv53kfilpc732qqxchcwgv2p0y24hnp";
    };

    config =
      if userModeLinux then ./config-2.6.20-uml else
      if stdenv.system == "i686-linux" then ./config-2.6.20-i686-smp else
      if stdenv.system == "x86_64-linux" then ./config-2.6.20-x86_64-smp else
      abort "No kernel configuration for your platform!";
  }

  // args
)
