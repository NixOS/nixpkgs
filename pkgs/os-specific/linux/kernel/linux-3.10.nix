{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "3.10.39";
  extraMeta.branch = "3.10";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/linux-${version}.tar.xz";
    sha256 = "1zl51dhcfyynii808mfvdjfq349wgfj1p4i8qbb786ancxam2ln4";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;
})
