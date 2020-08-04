{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.232";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0d7x30sy9c27n9bqf5f5mf64c6j5iljnw1gm7g8z00xgvrjqibjf";
  };
} // (args.argsOverride or {}))
