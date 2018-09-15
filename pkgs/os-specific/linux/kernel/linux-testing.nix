{ stdenv, buildPackages, fetchurl, perl, buildLinux, libelf, utillinux, ... } @ args:

buildLinux (args // rec {
  version = "4.19-rc3";
  modDirVersion = "4.19.0-rc3";
  extraMeta.branch = "4.19";

  src = fetchurl {
    url = "https://git.kernel.org/torvalds/t/linux-${version}.tar.gz";
    sha256 = "0n372r1j3m2q47hwl8b1r57jq1b4fdhmadgvcvik6fpsvcw74w27";
  };

  # Should the testing kernels ever be built on Hydra?
  extraMeta.hydraPlatforms = [];

} // (args.argsOverride or {}))
