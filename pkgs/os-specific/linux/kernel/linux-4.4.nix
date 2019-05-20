{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.180";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0ykai953rpy9zkb4qxb63y6pwwbwlnvx69nhb797zfw1scbh4i8s";
  };
} // (args.argsOverride or {}))
