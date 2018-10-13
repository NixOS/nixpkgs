{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.160";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1i0wqccab2xxjsx58pgzgbmm5cclfd3hh3yjasnfrqsdaarxvgkd";
  };
} // (args.argsOverride or {}))
