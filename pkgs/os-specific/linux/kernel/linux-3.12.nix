{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "3.12.55";
  extraMeta.branch = "3.12";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/linux-${version}.tar.xz";
    sha256 = "0xg52i6zsrkzv0i2kxrsx0179lkp9f2388r06rahx0anf4ars5p2";
  };

  kernelPatches = args.kernelPatches;

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;
})
