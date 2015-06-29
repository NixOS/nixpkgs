{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.1-rc8";
  modDirVersion = "4.1.0-rc8";
  extraMeta.branch = "4.1";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/testing/linux-${version}.tar.xz";
    sha256 = "0ia4lajpr3w9iivmwm2d7gqrpv97da5g4j8pkqa7q4mlr86jki2w";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;

  # Should the testing kernels ever be built on Hydra?
  extraMeta.hydraPlatforms = [];

} // (args.argsOverride or {}))
