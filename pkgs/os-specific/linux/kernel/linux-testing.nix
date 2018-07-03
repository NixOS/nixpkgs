{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, libelf, utillinux, ... } @ args:

buildLinux (args // rec {
  version = "4.18-rc3";
  modDirVersion = "4.18.0-rc3";
  extraMeta.branch = "4.18";

  src = fetchurl {
    url = "https://git.kernel.org/torvalds/t/linux-${version}.tar.gz";
    sha256 = "1kr9bhvcdp792micjmhl2hwhs5iid1srb4ia8hm4cpy1lnzdgrih";
  };

  # Should the testing kernels ever be built on Hydra?
  extraMeta.hydraPlatforms = [];

} // (args.argsOverride or {}))
