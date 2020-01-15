{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.191";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0x3lnq4xyj5v6r1cz4jizm4vdspws1nb806f5qczwi3yil5nm6bh";
  };
} // (args.argsOverride or {}))
