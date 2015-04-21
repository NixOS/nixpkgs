{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "3.14.39";
  # Remember to update grsecurity!
  extraMeta.branch = "3.14";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/linux-${version}.tar.xz";
    sha256 = "0zgfiqlvmprbn55k9ijf6db027mxlcww76y47g4g7vcj5qrpq6rd";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
