{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.0-rc1";
  modDirVersion = "4.0.0-rc1";
  extraMeta.branch = "4.0";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/testing/linux-${version}.tar.xz";
    sha256 = "0ri4m0gkniq69d5lfs1zgclrb42lnmhqb26ivi17ayn4g9nf4yql";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;

  # Should the testing kernels ever be built on Hydra?
  extraMeta.hydraPlatforms = [];

} // (args.argsOverride or {}))
