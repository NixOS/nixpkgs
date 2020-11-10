{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.242";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "089gigqali5q8izac82ybigxyi1bnw0xhm1cc590h4v7lkmk0mm1";
  };
} // (args.argsOverride or {}))
