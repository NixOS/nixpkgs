{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  # Reason to add:  RTL8192EE
  version = "3.16-rc1";
  modDirVersion = "3.16.0-rc1";
  extraMeta.branch = "3.16";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/testing/linux-${version}.tar.xz";
    sha256 = "1y2ssifw6db40mr4j6k9c0kjwb4ssrrps74pc38krq4d6yzinhmq";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;

  # Should the testing kernels ever be built on Hydra?
  extraMeta.hydraPlatforms = [];

} // (args.argsOverride or {}))
