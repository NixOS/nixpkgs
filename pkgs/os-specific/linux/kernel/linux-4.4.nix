{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.121";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0ad7djpbwapk126jddrnnq0a5a9mmhrr36qcnckc7388nml85a24";
  };
} // (args.argsOverride or {}))
