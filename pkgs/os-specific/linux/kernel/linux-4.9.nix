{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.223";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1r9ag1fhy0g429q44qlqh0qkf42qkhzxa04gxlmnrinqypk00lyg";
  };
} // (args.argsOverride or {}))
