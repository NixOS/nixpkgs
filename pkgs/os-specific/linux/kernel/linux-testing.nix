{ stdenv, buildPackages, fetchurl, perl, buildLinux, libelf, utillinux, ... } @ args:

buildLinux (args // rec {
  version = "5.1-rc5";
  modDirVersion = "5.1.0-rc5";
  extraMeta.branch = "5.1";

  src = fetchurl {
    url = "https://git.kernel.org/torvalds/t/linux-${version}.tar.gz";
    sha256 = "171caaf8zrjx124431a94sv25c0ka6b3ni194l7fpisn4n3x8y47";
  };

  # Should the testing kernels ever be built on Hydra?
  extraMeta.hydraPlatforms = [];

} // (args.argsOverride or {}))
