{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.0.2";
  # Remember to update grsecurity!
  extraMeta.branch = "4.0";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1jq4583wwqmwqkqlkck57fxw18xszng92b6ma3avf0djd11b2izz";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
