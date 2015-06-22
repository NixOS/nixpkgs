{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.1";
  modDirVersion = "4.1.0";
  extraMeta.branch = "4.1";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "17rdly75zh49m6r32yy03xappl7ajcqbznq09pm1q7mcb841zxfa";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
