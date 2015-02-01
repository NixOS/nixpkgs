{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "3.19-rc6";
  modDirVersion = "3.19.0-rc6";
  extraMeta.branch = "3.19";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/testing/linux-${version}.tar.xz";
    sha256 = "04lb9fh85y68zhhyzimvgzjz6qngjszkavklfhd4sly70f8i6bsh";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;

  # Should the testing kernels ever be built on Hydra?
  extraMeta.hydraPlatforms = [];

} // (args.argsOverride or {}))
