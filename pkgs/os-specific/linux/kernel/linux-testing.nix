{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, libelf, utillinux, ... } @ args:

buildLinux (args // rec {
  version = "4.18-rc5";
  modDirVersion = "4.18.0-rc5";
  extraMeta.branch = "4.18";

  src = fetchurl {
    url = "https://git.kernel.org/torvalds/t/linux-${version}.tar.gz";
    sha256 = "1r7ia0dc4p8xvyrl5kx9v7ii1m25ly0hg6xyz3zwhaailg1y4jzk";
  };

  # Should the testing kernels ever be built on Hydra?
  extraMeta.hydraPlatforms = [];

} // (args.argsOverride or {}))
