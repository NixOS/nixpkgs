{ stdenv, buildPackages, fetchurl, perl, buildLinux, libelf, utillinux, ... } @ args:

buildLinux (args // rec {
  version = "4.19-rc5";
  modDirVersion = "4.19.0-rc5";
  extraMeta.branch = "4.19";

  src = fetchurl {
    url = "https://git.kernel.org/torvalds/t/linux-${version}.tar.gz";
    sha256 = "0fpv2g6x1hgdrxvh1acjcxmyk2fzqcx1ypi0mqw72swbm587irck";
  };

  # Should the testing kernels ever be built on Hydra?
  extraMeta.hydraPlatforms = [];

} // (args.argsOverride or {}))
