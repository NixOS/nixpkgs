{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.159";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1hivz1pyy4scp4s09ibz36ni4d1pwivizwls5dbh5qjy0pdvn00f";
  };
} // (args.argsOverride or {}))
