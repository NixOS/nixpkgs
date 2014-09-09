{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "3.15.10";
  extraMeta.branch = "3.15";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/linux-${version}.tar.xz";
    sha256 = "1x057a1pfr4rqzmjdb3x1bwwl6gzr6im8dg8f6anwz9fnps6vv5d";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
