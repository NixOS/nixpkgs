{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.229";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0crrawivri5i0ks7pg3snfjlxily4aimw5xzbzr5nlnsz0rjwhbq";
  };
} // (args.argsOverride or {}))
