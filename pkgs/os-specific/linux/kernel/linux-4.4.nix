{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.186";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "113rjf8842glzi23y1g1yrwncihv2saah6wz0r726r06bk9p64hb";
  };
} // (args.argsOverride or {}))
