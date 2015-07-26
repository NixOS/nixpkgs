{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.1.3";
  extraMeta.branch = "4.1";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "02z3palvki31qimmycz4y4wl4lb46n662qql46iah224k0q2rpcn";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
