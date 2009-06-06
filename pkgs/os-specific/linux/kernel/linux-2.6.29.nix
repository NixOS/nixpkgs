args @ {stdenv, fetchurl, userModeLinux ? false, ...}:

assert !userModeLinux;

import ./generic.nix (

  rec {
    version = "2.6.29.4";
  
    src = fetchurl {
      url = "mirror://kernel/linux/kernel/v2.6/linux-${version}.tar.bz2";
      sha256 = "1v6kpym0d0s2cwxpc3q6ja1sqyj9vn5cbpa1rkmr5vvi1y83yw24";
    };

    features = {
      iwlwifi = true;
    };
 
    config =
      if stdenv.system == "i686-linux" then ./config-2.6.29-i686-smp else
      if stdenv.system == "x86_64-linux" then ./config-2.6.29-x86_64-smp else
      abort "No kernel configuration for your platform!";
  }

  // args
)
