{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.1-rc5";
  modDirVersion = "4.1.0-rc5";
  extraMeta.branch = "4.1";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/testing/linux-${version}.tar.xz";
    sha256 = "0kqw5y5p8x1qyljlzj78vhg5zmj9ngn3m76c9qyji6izclh3y8vv";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;

  # Should the testing kernels ever be built on Hydra?
  extraMeta.hydraPlatforms = [];

} // (args.argsOverride or {}))
