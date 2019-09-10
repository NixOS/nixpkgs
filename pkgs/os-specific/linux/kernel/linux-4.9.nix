{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.192";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0m4d6b5sfcx3iv0agia080fbcn9icyqzgzxp946zv93hrq6306ks";
  };
} // (args.argsOverride or {}))
