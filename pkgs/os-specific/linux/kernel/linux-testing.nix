{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.1-rc6";
  modDirVersion = "4.1.0-rc6";
  extraMeta.branch = "4.1";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/testing/linux-${version}.tar.xz";
    sha256 = "0b8ylsrnvwf0fsq6i0iar7h92z7q3356rh1x3a5wb5p0q5j7lldr";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;

  # Should the testing kernels ever be built on Hydra?
  extraMeta.hydraPlatforms = [];

} // (args.argsOverride or {}))
