{ stdenv, hostPlatform, fetchgit, perl, buildLinux, ... } @ args:

import ./generic.nix (args // rec {
  modDirVersion = "4.13.0-rc1";
  version = "${modDirVersion}-linux-tegra";
  extraMeta.branch = "4.13";

  src = fetchgit {
    url = "https://git.kernel.org/pub/scm/linux/kernel/git/tegra/linux.git";
    rev = "20e72aa386b007d96d1ce444ffc6152baf9dcb2f";
    sha256 = "1xd0fr7hpfa9f7nfr06flbi74ilcf4lrsrgf5q5fnyv2ryzix14k";
  };

  extraMeta.hydraPlatforms = [];

} // (args.argsOverride or {}))
