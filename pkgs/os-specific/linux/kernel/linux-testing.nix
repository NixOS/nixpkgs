{ stdenv, buildPackages, fetchurl, perl, buildLinux, libelf, utillinux, ... } @ args:

buildLinux (args // rec {
  version = "5.0-rc5";
  modDirVersion = "5.0.0-rc5";
  extraMeta.branch = "5.0";

  src = fetchurl {
    url = "https://git.kernel.org/torvalds/t/linux-${version}.tar.gz";
    sha256 = "0a60svgiz06cq4hq5z1rmwyjq1748fm7wi87arl659aidp0r0qky";
  };

  # Should the testing kernels ever be built on Hydra?
  extraMeta.hydraPlatforms = [];

} // (args.argsOverride or {}))
