{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, libelf, utillinux, ... } @ args:

buildLinux (args // rec {
  version = "4.17-rc7";
  modDirVersion = "4.17.0-rc7";
  extraMeta.branch = "4.17";

  src = fetchurl {
    url = "https://git.kernel.org/torvalds/t/linux-${version}.tar.gz";
    sha256 = "0kibvll2h4wvfbfxral7jsjajaijw0jb0scpjascwh66d7cxbbbr";
  };

  # Should the testing kernels ever be built on Hydra?
  extraMeta.hydraPlatforms = [];

} // (args.argsOverride or {}))
