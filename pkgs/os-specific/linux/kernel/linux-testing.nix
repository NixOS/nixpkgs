{ stdenv, fetchurl, perl, buildLinux, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.3-rc7";
  modDirVersion = "4.3.0-rc7";
  extraMeta.branch = "4.3";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/testing/linux-${version}.tar.xz";
    sha256 = "01ip9w3yv8x8i0mbz0gi64rd4jjc8vcalgrx656kq33kvab7s1ys";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;

  # Should the testing kernels ever be built on Hydra?
  extraMeta.hydraPlatforms = [];

} // (args.argsOverride or {}))
