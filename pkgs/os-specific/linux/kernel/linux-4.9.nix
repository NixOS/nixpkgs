{ buildPackages, fetchurl, perl, buildLinux, nixosTests, stdenv, ... } @ args:

buildLinux (args // rec {
  version = "4.9.299";
  extraMeta.branch = "4.9";
  extraMeta.broken = stdenv.isAarch64;

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1n0y8hi7ljs9jr3viqhbpshq0wapmyqb8d9vlh4yzg2n5y5qs3l1";
  };
} // (args.argsOverride or {}))
