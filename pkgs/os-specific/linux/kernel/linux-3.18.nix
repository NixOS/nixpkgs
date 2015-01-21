{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "3.18.3";
  # Remember to update grsecurity!
  extraMeta.branch = "3.18";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/linux-${version}.tar.xz";
    sha256 = "0ma2x68975xsi9kb15p0615nx9sm5ppb309kfdz7fgx9pg84q0hf";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
