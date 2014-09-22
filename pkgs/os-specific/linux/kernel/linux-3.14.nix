{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "3.14.19";
  extraMeta.branch = "3.14";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/linux-${version}.tar.xz";
    sha256 = "0qf5pq0w63fhd5aql4b50g1wvr38jrrr428s7ns2df2dp5nws5y3";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
