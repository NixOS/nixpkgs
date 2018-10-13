{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.161";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "11rz66qvbcb6y3fz9k04jzn547sqdahqknd43imsr9sjgkaq60xy";
  };
} // (args.argsOverride or {}))
