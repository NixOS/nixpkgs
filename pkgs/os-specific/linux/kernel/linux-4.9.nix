{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.168";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "07h9xwxpdxb6gm1fy0d8s6p1zalmw3mbzjgd4gipvmzsxwhiqiad";
  };
} // (args.argsOverride or {}))
