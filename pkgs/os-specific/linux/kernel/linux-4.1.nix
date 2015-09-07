{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.1.6";
  # Remember to update grsecurity!
  extraMeta.branch = "4.1";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1zlr7d5d7rhcbpwsi0svmv0zwj50n6mj6xgfzwwi336f5p26wbci";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
