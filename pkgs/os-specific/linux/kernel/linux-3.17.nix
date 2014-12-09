{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "3.17.6";
  # Remember to update grsecurity!
  extraMeta.branch = "3.17";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/linux-${version}.tar.xz";
    sha256 = "0z4xai2m8s6zd4mkxsa8dw2ny378y6p9l835z4xj8xwgl30hjaa1";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
