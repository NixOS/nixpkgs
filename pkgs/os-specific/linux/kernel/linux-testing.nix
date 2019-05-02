{ stdenv, buildPackages, fetchurl, perl, buildLinux, libelf, utillinux, ... } @ args:

buildLinux (args // rec {
  version = "5.1-rc7";
  modDirVersion = "5.1.0-rc7";
  extraMeta.branch = "5.1";

  src = fetchurl {
    url = "https://git.kernel.org/torvalds/t/linux-${version}.tar.gz";
    sha256 = "05085j84kn3mf5s2hy8i9jgvnglpr9v918kmc9lmpn5vq7frh9s1";
  };

  # Should the testing kernels ever be built on Hydra?
  extraMeta.hydraPlatforms = [];

} // (args.argsOverride or {}))
