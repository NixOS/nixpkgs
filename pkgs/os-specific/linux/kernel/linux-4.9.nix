{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.240";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0vvpvw5wsvjnwch5ci63x08qc7qyzpyxbiaxx4521nl8d7371r06";
  };
} // (args.argsOverride or {}))
