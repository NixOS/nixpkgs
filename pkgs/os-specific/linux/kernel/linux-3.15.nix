{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "3.15";
  extraMeta.branch = "3.15";
  modDirVersion = "3.15.0";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/linux-${version}.tar.xz";
    sha256 = "153pn0zjzgi3ls4gy12n900ayskpq0yncn0vra5glh20ps3px4n3";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
