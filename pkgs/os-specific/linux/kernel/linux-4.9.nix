{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.249";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0kjcw0vgga9msgqnipgg028v3rcc5am2d094v3hqkkjvzyb8dwxi";
  };
} // (args.argsOverride or {}))
