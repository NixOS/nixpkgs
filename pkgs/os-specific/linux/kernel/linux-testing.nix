{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  # Reason to add:  RTL8192EE
  version = "3.16-rc2";
  modDirVersion = "3.16.0-rc2";
  extraMeta.branch = "3.16";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/testing/linux-${version}.tar.xz";
    sha256 = "12bxf62qqsf471ak6rj4gbvvjsybsamgwj9p8bphr98dp14js27w";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;

  # Should the testing kernels ever be built on Hydra?
  extraMeta.hydraPlatforms = [];

} // (args.argsOverride or {}))
