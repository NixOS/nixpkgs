{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.0.8";
  # Remember to update grsecurity!
  extraMeta.branch = "4.0";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1cggqi5kdan818xw5g5wmapcsf501f5m9bympsy6a2cpphknfdmn";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
