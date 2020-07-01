{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.229";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1p0g6zya8bdk2fds37x3fg7c5sk3sc18prq3jrrilnnrby1w4mij";
  };
} // (args.argsOverride or {}))
