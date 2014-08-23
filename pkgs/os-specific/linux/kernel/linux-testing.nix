{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  # Reason to add:  RTL8192EE
  version = "3.16-rc3";
  modDirVersion = "3.16.0-rc3";
  extraMeta.branch = "3.16";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/testing/linux-${version}.tar.xz";
    sha256 = "17jgv1hnx2im68f8721x11yfg8mpas7lsxg0j00qxv2fc6km2glm";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;

  # Should the testing kernels ever be built on Hydra?
  extraMeta.hydraPlatforms = [];

} // (args.argsOverride or {}))
