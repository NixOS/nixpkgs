{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.0.3";
  # Remember to update grsecurity!
  extraMeta.branch = "4.0";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1djkbqrzi898qr2n0cd4m8casfj8pvgydc98l4ws3w8l9ikgwxw4";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
