{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "3.19-rc7";
  modDirVersion = "3.19.0-rc7";
  extraMeta.branch = "3.19";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/testing/linux-${version}.tar.xz";
    sha256 = "007xjngbyvdx127rkrzxs23kxcw2z54gzad9954iwhphqw0kpq9x";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;

  # Should the testing kernels ever be built on Hydra?
  extraMeta.hydraPlatforms = [];

} // (args.argsOverride or {}))
