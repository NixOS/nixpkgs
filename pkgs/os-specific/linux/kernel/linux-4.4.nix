{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.250";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "12m14j8654rawj2znkyhvcnwnf53x10zlghxd0mpl8dfzwvn2f5b";
  };
} // (args.argsOverride or {}))
