{ stdenv, hostPlatform, fetchurl, perl, buildLinux, libelf, utillinux, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.15-rc7";
  modDirVersion = "4.15.0-rc7";
  extraMeta.branch = "4.15";

  src = fetchurl {
    url = "https://git.kernel.org/torvalds/t/linux-${version}.tar.gz";
    sha256 = "1ph3asz5cc82mj7vb5cd5n80wnf66cm9jrlpa66da8kz8za0cdkh";
  };

  # Should the testing kernels ever be built on Hydra?
  extraMeta.hydraPlatforms = [];

} // (args.argsOverride or {}))
