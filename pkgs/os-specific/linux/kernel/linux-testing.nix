{ stdenv, buildPackages, fetchurl, perl, buildLinux, libelf, utillinux, ... } @ args:

buildLinux (args // rec {
  version = "5.2-rc4";
  modDirVersion = "5.2.0-rc4";
  extraMeta.branch = "5.2";

  src = fetchurl {
    url = "https://git.kernel.org/torvalds/t/linux-${version}.tar.gz";
    sha256 = "0j5vvmbndmjyal3sd98a9lr0x6lxarbz46rgp197f6sf628gxahq";
  };

  # Should the testing kernels ever be built on Hydra?
  extraMeta.hydraPlatforms = [];

} // (args.argsOverride or {}))
