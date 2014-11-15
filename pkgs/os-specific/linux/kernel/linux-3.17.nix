{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "3.17.3";
  # Remember to update grsecurity!
  extraMeta.branch = "3.17";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/linux-${version}.tar.xz";
    sha256 = "1hkjq74ap4ll6s2fmmrbmqybfz6sqwciyrq75m1xcjnvjaim9zzi";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
