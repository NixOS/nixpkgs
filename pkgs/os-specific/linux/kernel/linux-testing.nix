{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, libelf, utillinux, ... } @ args:

buildLinux (args // rec {
  version = "4.17-rc1";
  modDirVersion = "4.17.0-rc1";
  extraMeta.branch = "4.17";

  src = fetchurl {
    url = "https://git.kernel.org/torvalds/t/linux-${version}.tar.gz";
    sha256 = "0a3lrax6f8f98lj65aawpqkzkmxcl2x4h20kr0cr7wf0jvpnn5y3";
  };

  # Should the testing kernels ever be built on Hydra?
  extraMeta.hydraPlatforms = [];

} // (args.argsOverride or {}))
