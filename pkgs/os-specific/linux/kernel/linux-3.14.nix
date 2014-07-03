{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "3.14.10";
  extraMeta.branch = "3.14";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/linux-${version}.tar.xz";
    sha256 = "10gf1r3xnix4v2az7i9dxnddmi377hhlbyblgm0nz9sxddgmk36z";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
