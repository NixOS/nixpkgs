{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "3.19-rc5";
  modDirVersion = "3.19.0-rc5";
  extraMeta.branch = "3.19";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/testing/linux-${version}.tar.xz";
    sha256 = "1n1bzdczqi9lqb6sahm1g9f59v1h6vp6r4skyi40dk3v2xacb0nw";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;

  # Should the testing kernels ever be built on Hydra?
  extraMeta.hydraPlatforms = [];

} // (args.argsOverride or {}))
