{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.145";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1max0d1b1y1ndrfprrcyb7c9y12pkx2whxzlr70qypcb5jz0v7ff";
  };
} // (args.argsOverride or {}))
