{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.142";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "01n4v0gpf8xyz8hzc70mhjha7kanz9pv248ypsmab7zpzgd7wjil";
  };
} // (args.argsOverride or {}))
