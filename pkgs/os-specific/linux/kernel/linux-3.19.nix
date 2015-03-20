{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "3.19.2";
  # Remember to update grsecurity!
  extraMeta.branch = "3.19";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/linux-${version}.tar.xz";
    sha256 = "0b8bfpfpyrpccb8v4nld0a0siricg8f3awmhz8wn4kwdvhhf83hc";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
