{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.199";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1w35j5w9jjlnwl0bis376gh3l6jsy9vpvcpaihr4pj872jcv0f8p";
  };
} // (args.argsOverride or {}))
