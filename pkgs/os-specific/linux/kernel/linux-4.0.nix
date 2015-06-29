{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.0.6";
  # Remember to update grsecurity!
  extraMeta.branch = "4.0";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0n0w2k52m3cn286f413jmzwffyk3g28y4n7d41wc93zvgm720lr9";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
