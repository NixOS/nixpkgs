{ stdenv, buildPackages, fetchurl, perl, buildLinux, libelf, utillinux, ... } @ args:

buildLinux (args // rec {
  version = "4.19-rc6";
  modDirVersion = "4.19.0-rc6";
  extraMeta.branch = "4.19";

  src = fetchurl {
    url = "https://git.kernel.org/torvalds/t/linux-${version}.tar.gz";
    sha256 = "0cq0xr4lwvngyiyall62hddbk27gy72zjiigb8xdsry96a8ccvgl";
  };

  # Should the testing kernels ever be built on Hydra?
  extraMeta.hydraPlatforms = [];

} // (args.argsOverride or {}))
