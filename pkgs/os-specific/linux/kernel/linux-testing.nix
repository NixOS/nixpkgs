{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.0-rc6";
  modDirVersion = "4.0.0-rc6";
  extraMeta.branch = "4.0";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/testing/linux-${version}.tar.xz";
    sha256 = "1f6xqrc9lqssr2gyzd6d82dk2niikbr1swg68vfc250am0l55vw8";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;

  # Should the testing kernels ever be built on Hydra?
  extraMeta.hydraPlatforms = [];

} // (args.argsOverride or {}))
