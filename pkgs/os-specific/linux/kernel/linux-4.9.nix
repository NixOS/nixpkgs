{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.110";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0ypaqj9vs2jc4qiss5yyplx09rk55fa3hrlzdkm0x7x7f0x196ip";
  };
} // (args.argsOverride or {}))
