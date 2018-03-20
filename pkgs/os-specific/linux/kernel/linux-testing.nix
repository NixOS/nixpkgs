{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, libelf, utillinux, ... } @ args:

buildLinux (args // rec {
  version = "4.16-rc6";
  modDirVersion = "4.16.0-rc6";
  extraMeta.branch = "4.16";

  src = fetchurl {
    url = "https://git.kernel.org/torvalds/t/linux-${version}.tar.gz";
    sha256 = "0kwn1qj44pyb404qhwm4qr8mmfni8qfh1raf010d62i48n7pgv0d";
  };

  # Should the testing kernels ever be built on Hydra?
  extraMeta.hydraPlatforms = [];

} // (args.argsOverride or {}))
