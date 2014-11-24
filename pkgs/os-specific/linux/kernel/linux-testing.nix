{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "3.18-rc6";
  modDirVersion = "3.18.0-rc6";
  extraMeta.branch = "3.18";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/testing/linux-${version}.tar.xz";
    sha256 = "03flqar4jgaw042bf1v9ay3sg6y18irqklbpxk5x1g1yyjpbc6h8";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;

  # Should the testing kernels ever be built on Hydra?
  extraMeta.hydraPlatforms = [];

} // (args.argsOverride or {}))
