{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, libelf, utillinux, ... } @ args:

buildLinux (args // rec {
  version = "4.18-rc1";
  modDirVersion = "4.18.0-rc1";
  extraMeta.branch = "4.18";

  src = fetchurl {
    url = "https://git.kernel.org/torvalds/t/linux-${version}.tar.gz";
    sha256 = "1wzxnzhxmzn5gygxs1vm4iawknpivr5kn1mav8l1ll3q7s5xqjnr";
  };

  # Should the testing kernels ever be built on Hydra?
  extraMeta.hydraPlatforms = [];

} // (args.argsOverride or {}))
