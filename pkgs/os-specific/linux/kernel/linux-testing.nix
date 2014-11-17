{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "3.18-rc5";
  modDirVersion = "3.18.0-rc5";
  extraMeta.branch = "3.18";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/testing/linux-${version}.tar.xz";
    sha256 = "1dx354hsncx3r33y35c4f5baz75q5xs25yi5bgkszad1rlrg86sk";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;

  # Should the testing kernels ever be built on Hydra?
  extraMeta.hydraPlatforms = [];

} // (args.argsOverride or {}))
