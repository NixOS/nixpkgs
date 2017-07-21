{ stdenv, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.13-rc1";
  modDirVersion = "4.13.0-rc1";
  extraMeta.branch = "4.13";

  src = fetchurl {
    url = "https://git.kernel.org/torvalds/t/linux-${version}.tar.gz";
    sha256 = "1pdbykp2336vk7ynrz0l95rwqags6kklbr08wjc7zpmdaad6yd6m";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.netfilterRPFilter = true;

  # Should the testing kernels ever be built on Hydra?
  extraMeta.hydraPlatforms = [];

} // (args.argsOverride or {}))
