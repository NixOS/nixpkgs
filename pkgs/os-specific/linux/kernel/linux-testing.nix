{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.0-rc7";
  modDirVersion = "4.0.0-rc7";
  extraMeta.branch = "4.0";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/testing/linux-${version}.tar.xz";
    sha256 = "1261p44zmsaq7gf08b8sd9xng2y46d4v7jyfipjlgrrmlkyfgqki";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;

  # Should the testing kernels ever be built on Hydra?
  extraMeta.hydraPlatforms = [];

} // (args.argsOverride or {}))
