{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.136";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0svb6qbhc376jk26r67qssh7lradx63s60qlm1q2kd4xjhxyj5a3";
  };
} // (args.argsOverride or {}))
