{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "3.16.3";
  extraMeta.branch = "3.16";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/linux-${version}.tar.xz";
    sha256 = "1namhqsfr26pjwhrxh8agybdjk14337yyn6h12294dazjd7s74ak";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
