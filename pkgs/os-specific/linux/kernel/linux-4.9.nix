{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.161";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "19i8igx0pchzd9wgx595alcji8jxl4bpcg5zd33ymyamgq5q67p1";
  };
} // (args.argsOverride or {}))
