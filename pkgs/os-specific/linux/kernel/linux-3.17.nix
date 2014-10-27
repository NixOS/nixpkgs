{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "3.17.1";
  extraMeta.branch = "3.17";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/linux-${version}.tar.xz";
    sha256 = "1hhxsb4gsaj2mlmshivild7ayagam8f3xfl27n4652b1z4n0171c";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
