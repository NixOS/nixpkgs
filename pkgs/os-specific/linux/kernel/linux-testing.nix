{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.2-rc2";
  modDirVersion = "4.2.0-rc2";
  extraMeta.branch = "4.2";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/testing/linux-${version}.tar.xz";
    sha256 = "068g71ns8d2j66hppmnssilf185p33w7argb0r2w9kplqq2ac99w";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;

  # Should the testing kernels ever be built on Hydra?
  extraMeta.hydraPlatforms = [];

} // (args.argsOverride or {}))
