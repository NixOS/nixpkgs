{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, libelf, utillinux, ... } @ args:

buildLinux (args // rec {
  version = "4.18-rc7";
  modDirVersion = "4.18.0-rc7";
  extraMeta.branch = "4.18";

  src = fetchurl {
    url = "https://git.kernel.org/torvalds/t/linux-${version}.tar.gz";
    sha256 = "005kk7rxawkka60y31a5aiqrq3w6i1k27b5n2lcq63agjcxh54rq";
  };

  # Should the testing kernels ever be built on Hydra?
  extraMeta.hydraPlatforms = [];

} // (args.argsOverride or {}))
