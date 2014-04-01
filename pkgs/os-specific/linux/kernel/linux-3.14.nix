{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "3.14";
  extraMeta.branch = "3.14";
  modDirVersion = "3.14.0";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/linux-${version}.tar.xz";
    sha256 = "61558aa490855f42b6340d1a1596be47454909629327c49a5e4e10268065dffa";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
