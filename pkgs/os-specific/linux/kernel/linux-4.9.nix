{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.268";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0aknrlf5q0dsqib8c9klmf5c60dy7hg2zksb020qvyrp077gcrjv";
  };
} // (args.argsOverride or {}))
