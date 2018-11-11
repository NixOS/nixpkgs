{ stdenv, buildPackages, fetchurl, perl, buildLinux, libelf, utillinux, ... } @ args:

buildLinux (args // rec {
  version = "4.20-rc1";
  modDirVersion = "4.20.0-rc1";
  extraMeta.branch = "4.20";

  src = fetchurl {
    url = "https://git.kernel.org/torvalds/t/linux-${version}.tar.gz";
    sha256 = "0nf3rk8768740smkbf2ilsm40p1pnnmrpf53pmc5k1dkj4kgc0pb";
  };

  # Should the testing kernels ever be built on Hydra?
  extraMeta.hydraPlatforms = [];

} // (args.argsOverride or {}))
