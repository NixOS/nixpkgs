{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.252";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1shllgrmxi6darnyzwkzazzjhpwxhm19z1swv40hnm0pbvgxm7hw";
  };
} // (args.argsOverride or {}))
