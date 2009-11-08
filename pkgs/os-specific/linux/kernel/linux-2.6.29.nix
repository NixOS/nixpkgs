args @ {stdenv, fetchurl, userModeLinux ? false, ...}:

assert !userModeLinux;

import ./generic.nix (

  rec {
    version = "2.6.29.6";
  
    src = fetchurl {
      url = "mirror://kernel/linux/kernel/v2.6/linux-${version}.tar.bz2";
      sha256 = "1yf5xhdnpcyhw4y78v35wyidlsyzxvbbnzw6jd31zni7ira6jvjk";
    };

    features = {
      iwlwifi = true;
    };
 
    config =
      if stdenv.system == "i686-linux" then ./config-2.6.29-i686-smp else
      if stdenv.system == "x86_64-linux" then ./config-2.6.29-x86_64-smp else
      if stdenv.system == "armv5tel-linux" then ./config-2.6.29-arm else
      abort "No kernel configuration for your platform!";
  }

  // args
)
