args @ {stdenv, fetchurl, userModeLinux ? false, ...}:

assert !userModeLinux;

import ./generic.nix (

  let
    baseVersion = "2.6.30"; 
  in

  rec {
    version = "2.6.31-rc3";
  
    src = fetchurl {
      url = "mirror://kernel/linux/kernel/v2.6/linux-${baseVersion}.tar.bz2";
      sha256 = "1yf5xhdnpcyhw4y78v35wyidlsyzxvbbnzw6jd31zni7ira6jvjk";
    };

    features = {
      iwlwifi = true;
    };
 
    config =
      if stdenv.system == "i686-linux" then ./config-2.6.31-rc3-all-mod-i686 else
      #if stdenv.system == "x86_64-linux" then ./config-2.6.29-x86_64-smp else
      abort "No kernel configuration for your platform!";
  }

  // args
)
