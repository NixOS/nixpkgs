{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.149";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "10yp6pf91h927bxnb32qd6y13m0a230d44gp70ifd6cg5ssd6nqn";
  };
} // (args.argsOverride or {}))
