{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.123";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "115mvgwcx2syjrn943k4qqyvqkysdm6rgq97dhf1gcxf671qb204";
  };
} // (args.argsOverride or {}))
