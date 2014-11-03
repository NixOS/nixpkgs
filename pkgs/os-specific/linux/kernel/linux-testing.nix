{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "3.18-rc3";
  modDirVersion = "3.18.0-rc3";
  extraMeta.branch = "3.18";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/testing/linux-${version}.tar.xz";
    sha256 = "1w58szpljzm2ys53fiagqypiw9ylbqf843rwqyv9bwxg5lm1jaq1";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;

  # Should the testing kernels ever be built on Hydra?
  extraMeta.hydraPlatforms = [];

} // (args.argsOverride or {}))
