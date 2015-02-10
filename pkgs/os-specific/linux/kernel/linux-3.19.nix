{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "3.19";
  modDirVersion = "3.19.0";
  # Remember to update grsecurity!
  extraMeta.branch = "3.19";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/linux-${version}.tar.xz";
    sha256 = "0v40b5l6dcviqgl47bxlcbimz7kawmy1c2909axi441jwlgm2hmy";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
