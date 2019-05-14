{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.175";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "032h0zd3rxg34vyp642978pbx66gnx3sfv49qwvbzwlx3zwk916r";
  };
} // (args.argsOverride or {}))
