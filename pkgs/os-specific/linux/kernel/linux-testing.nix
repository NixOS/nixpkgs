{ stdenv, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.14-rc2";
  modDirVersion = "4.14.0-rc2";
  extraMeta.branch = "4.14";

  src = fetchurl {
    url = "https://git.kernel.org/torvalds/t/linux-${version}.tar.gz";
    sha256 = "0ahcmr0y9i47lwjn140w436hg68apnh8rl66y56qdvdic8f61mj4";
  };

  # Should the testing kernels ever be built on Hydra?
  extraMeta.hydraPlatforms = [];

} // (args.argsOverride or {}))
