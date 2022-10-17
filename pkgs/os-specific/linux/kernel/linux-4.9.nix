{ buildPackages, fetchurl, perl, buildLinux, nixosTests, stdenv, ... } @ args:

buildLinux (args // rec {
  version = "4.9.330";
  extraMeta.branch = "4.9";
  extraMeta.broken = stdenv.isAarch64;

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0psrl8fcbp1bsanjmllic503dlyhkj8bjzfc20p2ksahlhv1j0mz";
  };
} // (args.argsOverride or {}))
