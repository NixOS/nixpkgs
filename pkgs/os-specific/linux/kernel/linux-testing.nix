{ stdenv, buildPackages, fetchurl, perl, buildLinux, libelf, utillinux, ... } @ args:

buildLinux (args // rec {
  version = "5.2-rc1";
  modDirVersion = "5.2.0-rc1";
  extraMeta.branch = "5.2";

  src = fetchurl {
    url = "https://git.kernel.org/torvalds/t/linux-${version}.tar.gz";
    sha256 = "169gjmciijgmwwfyz3n7pvf2x18pmfvgdk73s8jlx30ggwzgac1l";
  };

  # Should the testing kernels ever be built on Hydra?
  extraMeta.hydraPlatforms = [];

} // (args.argsOverride or {}))
