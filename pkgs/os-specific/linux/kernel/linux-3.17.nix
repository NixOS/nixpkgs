{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "3.17.4";
  # Remember to update grsecurity!
  extraMeta.branch = "3.17";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/linux-${version}.tar.xz";
    sha256 = "0ayh9y58iv38h76jl2r77856af2cazzkwcdhjqmccibajjf42maa";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
