{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, libelf, utillinux, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.15-rc8";
  modDirVersion = "4.15.0-rc8";
  extraMeta.branch = "4.15";

  src = fetchurl {
    url = "https://git.kernel.org/torvalds/t/linux-${version}.tar.gz";
    sha256 = "15d24b47mfkfs2b0l54sq0yl3ylh5dnx23jknb2r7cq14wxiqmq3";
  };

  # Should the testing kernels ever be built on Hydra?
  extraMeta.hydraPlatforms = [];

} // (args.argsOverride or {}))
