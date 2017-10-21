{ stdenv, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.14-rc5";
  modDirVersion = "4.14.0-rc5";
  extraMeta.branch = "4.14";

  src = fetchurl {
    url = "https://git.kernel.org/torvalds/t/linux-${version}.tar.gz";
    sha256 = "1y383vw79jhpr15s919xwzxif2y8zbiwa64sg2aan075xfhzijp8";
  };

  # Should the testing kernels ever be built on Hydra?
  extraMeta.hydraPlatforms = [];

} // (args.argsOverride or {}))
