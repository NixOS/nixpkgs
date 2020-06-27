{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.228";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0d7w2zzs79ywxzfrh4bmk5lw318qbkcb8mcsyyh3cc25qqlz9gwg";
  };
} // (args.argsOverride or {}))
