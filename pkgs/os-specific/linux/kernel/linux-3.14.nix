{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "3.14.4";
  extraMeta.branch = "3.14";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/linux-${version}.tar.xz";
    sha256 = "05yp192pbjng92rpvq3fd4mhjc96iylwf6xb7as5lscwg660m1b5";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
