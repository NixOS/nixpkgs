{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.174";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0n2qhvvphv45fckrhvcf58va8mv2j7pg7yvr2yxmbzvz0xlgv17w";
  };
} // (args.argsOverride or {}))
