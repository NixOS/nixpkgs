{ stdenv, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.14-rc7";
  modDirVersion = "4.14.0-rc7";
  extraMeta.branch = "4.14";

  src = fetchurl {
    url = "https://git.kernel.org/torvalds/t/linux-${version}.tar.gz";
    sha256 = "1w7b1sc5dsxcqywsdbwgs92i8jpj7hsnss67yzb58z3bz3hb73m3";
  };

  # Should the testing kernels ever be built on Hydra?
  extraMeta.hydraPlatforms = [];

} // (args.argsOverride or {}))
