{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "3.8.13";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/linux-${version}.tar.xz";
    sha256 = "0pznsj89020fjl8dhcyf7r5bh95b27727gs0ri9has4i2z63blbw";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;
})
