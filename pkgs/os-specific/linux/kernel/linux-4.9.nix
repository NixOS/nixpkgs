{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.251";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "03cn3yzyv8vwvv76nxj655i14s9avhr4hcc18mq2rh0qn6zcnkgg";
  };
} // (args.argsOverride or {}))
