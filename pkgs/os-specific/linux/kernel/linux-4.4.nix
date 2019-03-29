{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.177";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1gy0xm9hpfl8x3rxgm461yd4pnigbsgyxjb69bdpl3sqgz2225sj";
  };
} // (args.argsOverride or {}))
