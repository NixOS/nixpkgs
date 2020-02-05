{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.213";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0r7bqpvbpiiniwsm338b38mv6flfgm1r09avxqsakhkh8rvgz1dg";
  };
} // (args.argsOverride or {}))
