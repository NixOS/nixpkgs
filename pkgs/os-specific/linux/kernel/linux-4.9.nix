{ buildPackages, fetchurl, perl, buildLinux, nixosTests, stdenv, ... } @ args:

buildLinux (args // rec {
  version = "4.9.288";
  extraMeta.branch = "4.9";
  extraMeta.broken = stdenv.isAarch64;

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0v5592v565bl924c23m1n7p5zddr0w7zn8m97pmikk6p7cyhjq9n";
  };
} // (args.argsOverride or {}))
