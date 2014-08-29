{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "3.17-rc2";
  modDirVersion = "3.17.0-rc2";
  extraMeta.branch = "3.17";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/testing/linux-${version}.tar.xz";
    sha256 = "094r4kqp7bj1wcdfsgdmv73law4zb7d0sd8lw82v3rz944mlm9y3";
  };

  kernelPatches = args.kernelPatches ++ [ { name = "3.17-buildfix.patch"; patch = ./3.17-buildfix.patch; } ];

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;

  # Should the testing kernels ever be built on Hydra?
  extraMeta.hydraPlatforms = [];

} // (args.argsOverride or {}))
