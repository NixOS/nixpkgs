{ stdenv, buildPackages, fetchurl, perl, buildLinux, libelf, utillinux, ... } @ args:

buildLinux (args // rec {
  version = "5.0-rc7";
  modDirVersion = "5.0.0-rc7";
  extraMeta.branch = "5.0";

  src = fetchurl {
    url = "https://git.kernel.org/torvalds/t/linux-${version}.tar.gz";
    sha256 = "0x5jvv4n9l1gisc0q9m9r7173d9qwpl6crd59fbmasbmvi9lnp41";
  };

  # Should the testing kernels ever be built on Hydra?
  extraMeta.hydraPlatforms = [];

} // (args.argsOverride or {}))
