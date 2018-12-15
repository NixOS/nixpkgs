{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.145";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0pmwnnjk05xpw9qvzl59llf4ihjdicrm52ardkra41f3x0vwl0b9";
  };
} // (args.argsOverride or {}))
