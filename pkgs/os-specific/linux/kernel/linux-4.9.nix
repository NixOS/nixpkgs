{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.238";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0gsa2g5yjc7459ja107nla700ma32sg57dyj8q2xzi0yfw5zdsmi";
  };
} // (args.argsOverride or {}))
