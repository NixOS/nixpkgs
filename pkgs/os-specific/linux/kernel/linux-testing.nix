{ stdenv, buildPackages, fetchurl, perl, buildLinux, libelf, utillinux, ... } @ args:

buildLinux (args // rec {
  version = "5.2-rc5";
  modDirVersion = "5.2.0-rc5";
  extraMeta.branch = "5.2";

  src = fetchurl {
    url = "https://git.kernel.org/torvalds/t/linux-${version}.tar.gz";
    sha256 = "0av5kfwa0s2vip7bzrzgslyaww1z22zwyvl7jcfjfsaqfxdyyya0";
  };

  # Should the testing kernels ever be built on Hydra?
  extraMeta.hydraPlatforms = [];

} // (args.argsOverride or {}))
