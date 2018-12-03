{ stdenv, buildPackages, fetchurl, perl, buildLinux, libelf, utillinux, ... } @ args:

buildLinux (args // rec {
  version = "4.20-rc5";
  modDirVersion = "4.20.0-rc5";
  extraMeta.branch = "4.20";

  src = fetchurl {
    url = "https://git.kernel.org/torvalds/t/linux-${version}.tar.gz";
    sha256 = "0dixig8vismk40x4a719psyi39nqcv7yrisjdnj3s2ym9rljyypz";
  };

  # Should the testing kernels ever be built on Hydra?
  extraMeta.hydraPlatforms = [];

} // (args.argsOverride or {}))
