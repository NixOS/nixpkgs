{ stdenv, buildPackages, fetchurl, perl, buildLinux, libelf, utillinux, ... } @ args:

buildLinux (args // rec {
  version = "5.2-rc2";
  modDirVersion = "5.2.0-rc2";
  extraMeta.branch = "5.2";

  src = fetchurl {
    url = "https://git.kernel.org/torvalds/t/linux-${version}.tar.gz";
    sha256 = "0fd6z6zx9a3ax5jyvxm7gmfzain26la5gf18fccxip7bfn72bj4f";
  };

  # Should the testing kernels ever be built on Hydra?
  extraMeta.hydraPlatforms = [];

} // (args.argsOverride or {}))
