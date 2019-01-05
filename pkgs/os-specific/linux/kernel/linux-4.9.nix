{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.148";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1559i06mcsa1d0kfnf6q1k5fldz2pbkrpg4snwddxa1508diarv0";
  };
} // (args.argsOverride or {}))
