{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "3.18.20";
  extraMeta.branch = "3.18";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/linux-${version}.tar.xz";
    sha256 = "1mwm9xgilsqnj95v3jn94dz9a108ggfm4ifb3kxsfsx5rcl5yy8d";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
