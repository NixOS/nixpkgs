{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, libelf, utillinux, ... } @ args:

buildLinux (args // rec {
  version = "4.17-rc4";
  modDirVersion = "4.17.0-rc4";
  extraMeta.branch = "4.17";

  src = fetchurl {
    url = "https://git.kernel.org/torvalds/t/linux-${version}.tar.gz";
    sha256 = "1y34hpzgxblwqslhsfsmzmpv9f3s936r93wgn4kmhkcwsm0in292";
  };

  # Should the testing kernels ever be built on Hydra?
  extraMeta.hydraPlatforms = [];

} // (args.argsOverride or {}))
