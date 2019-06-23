{ stdenv, buildPackages, fetchurl, perl, buildLinux, libelf, utillinux, ... } @ args:

buildLinux (args // rec {
  version = "5.2-rc6";
  modDirVersion = "5.2.0-rc6";
  extraMeta.branch = "5.2";

  src = fetchurl {
    url = "https://git.kernel.org/torvalds/t/linux-${version}.tar.gz";
    sha256 = "15lwy9596v5sw8c6mhpl9ilfcmm39snvvyajg08ycsg61i2s58v0";
  };

  # Should the testing kernels ever be built on Hydra?
  extraMeta.hydraPlatforms = [];

} // (args.argsOverride or {}))
