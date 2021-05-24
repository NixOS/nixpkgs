{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.269";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1pnggwc9i6hka21vvl4yd9pd38hpnym9z56m4mhl970ijl4zywbr";
  };
} // (args.argsOverride or {}))
