{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.100";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0z572csacfwn3kl3yaz4wpd7wkzabm42p2z4ysx5rq0kf4x6zfy5";
  };
} // (args.argsOverride or {}))
