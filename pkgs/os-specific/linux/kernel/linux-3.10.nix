{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "3.10.7";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/linux-${version}.tar.xz";
    sha256 = "15f7f7hgiryxvqnmyan1r6j4klfgm2r3jfqb4a00j14jiqyn7ni1";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;
})
