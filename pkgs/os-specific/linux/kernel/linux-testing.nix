{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, libelf, utillinux, ... } @ args:

buildLinux (args // rec {
  version = "4.15-rc9";
  modDirVersion = "4.15.0-rc9";
  extraMeta.branch = "4.15";

  src = fetchurl {
    url = "https://git.kernel.org/torvalds/t/linux-${version}.tar.gz";
    sha256 = "18xhy38fqyzg9yiljhdj2y0skjf2yhxvhzbija3is75wyv7g55l6";
  };

  # Should the testing kernels ever be built on Hydra?
  extraMeta.hydraPlatforms = [];

} // (args.argsOverride or {}))
