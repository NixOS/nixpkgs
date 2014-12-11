{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "3.18-rc7";
  modDirVersion = "3.18.0-rc7";
  extraMeta.branch = "3.18";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/testing/linux-${version}.tar.xz";
    sha256 = "1zq7jd33jq4ibvjdsj8cm4zlgjag7j8r7w7ajmzivr7npdb9fvvk";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;

  # Should the testing kernels ever be built on Hydra?
  extraMeta.hydraPlatforms = [];

} // (args.argsOverride or {}))
