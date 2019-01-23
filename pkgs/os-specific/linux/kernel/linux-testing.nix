{ stdenv, buildPackages, fetchurl, perl, buildLinux, libelf, utillinux, ... } @ args:

buildLinux (args // rec {
  version = "5.0-rc3";
  modDirVersion = "5.0.0-rc3";
  extraMeta.branch = "5.0";

  src = fetchurl {
    url = "https://git.kernel.org/torvalds/t/linux-${version}.tar.gz";
    sha256 = "03xw2zfa6cxy5vdfrfh536mh3gcm8hvj69ggpqixm8d1gqg0nln6";
  };

  # Should the testing kernels ever be built on Hydra?
  extraMeta.hydraPlatforms = [];

} // (args.argsOverride or {}))
