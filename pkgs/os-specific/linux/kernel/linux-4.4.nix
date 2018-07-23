{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.143";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0n737jdk9ms7v7zkhf45nfdg2jcyap4qpzxm162f4q9zz3sh0dif";
  };
} // (args.argsOverride or {}))
