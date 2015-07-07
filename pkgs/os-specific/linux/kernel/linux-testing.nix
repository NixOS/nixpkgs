{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.2-rc1";
  modDirVersion = "4.2.0-rc1";
  extraMeta.branch = "4.2";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/testing/linux-${version}.tar.xz";
    sha256 = "0a9zr1jf2c110lvd7wi4jxxk2iw6san31yh8hwlahkkb8kh4wliw";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;

  # Should the testing kernels ever be built on Hydra?
  extraMeta.hydraPlatforms = [];

} // (args.argsOverride or {}))
