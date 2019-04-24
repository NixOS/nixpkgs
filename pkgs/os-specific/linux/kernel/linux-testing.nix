{ stdenv, buildPackages, fetchurl, perl, buildLinux, libelf, utillinux, ... } @ args:

buildLinux (args // rec {
  version = "5.1-rc6";
  modDirVersion = "5.1.0-rc6";
  extraMeta.branch = "5.1";

  src = fetchurl {
    url = "https://git.kernel.org/torvalds/t/linux-${version}.tar.gz";
    sha256 = "0s751wb4xdcnljid03a3gi9pkql7fcvixh32aiclbmfz6gyvbykv";
  };

  # Should the testing kernels ever be built on Hydra?
  extraMeta.hydraPlatforms = [];

} // (args.argsOverride or {}))
