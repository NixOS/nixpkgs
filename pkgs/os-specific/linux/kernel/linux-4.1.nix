{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.1.1";
  extraMeta.branch = "4.1";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "12bfih081cbqlgmgq1fqdvvpxga5saj4kkvhawsl4fpg4mybrml8";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
