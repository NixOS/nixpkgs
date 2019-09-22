{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.194";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0kvlp2v4nvkilaanhpgwf8dkyfj24msaw0m38rbc4y51y69yhqvz";
  };
} // (args.argsOverride or {}))
