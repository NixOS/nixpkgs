{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "3.15.8";
  extraMeta.branch = "3.15";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/linux-${version}.tar.xz";
    sha256 = "012d793mg2lkxfs6rxqkl22p6899l620ssbsii1szfjhnynh1qjd";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
