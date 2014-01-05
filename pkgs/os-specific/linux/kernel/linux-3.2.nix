{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "3.2.53";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/linux-${version}.tar.xz";
    sha256 = "1fvg76g3ixyz8spzzmw5gdfr0ni9wzi2g745vphknnd9a9rgwjdm";
  };

  features.iwlwifi = true;
})
