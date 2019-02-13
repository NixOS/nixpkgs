{ stdenv, buildPackages, fetchurl, perl, buildLinux, libelf, utillinux, ... } @ args:

buildLinux (args // rec {
  version = "5.0-rc6";
  modDirVersion = "5.0.0-rc6";
  extraMeta.branch = "5.0";

  src = fetchurl {
    url = "https://git.kernel.org/torvalds/t/linux-${version}.tar.gz";
    sha256 = "1315hkjwgm97kh98y8ynsf6fy1b6yf4b74ws6d4s7dls70qzl3yw";
  };

  # Should the testing kernels ever be built on Hydra?
  extraMeta.hydraPlatforms = [];

} // (args.argsOverride or {}))
