{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.1-rc4";
  modDirVersion = "4.1.0-rc4";
  extraMeta.branch = "4.1";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/testing/linux-${version}.tar.xz";
    sha256 = "0l3rmlng7pn4r788km8cgs562cq2is2cgzy3capdnngwmfrfmrr2";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;

  # Should the testing kernels ever be built on Hydra?
  extraMeta.hydraPlatforms = [];

} // (args.argsOverride or {}))
