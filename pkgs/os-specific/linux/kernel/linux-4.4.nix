{ buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.256";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1z7vfy4h0mjvv0rcvvpb55x5fl16c6cgpcafz5gpjp0pw1p2lva8";
  };
} // (args.argsOverride or {}))
