{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.166";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1sxs7525432cbnzrf5i4dli213bwwk3w1qfaamfx6ddwgh47ry5q";
  };
} // (args.argsOverride or {}))
