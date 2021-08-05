{ buildPackages, fetchurl, perl, buildLinux, nixosTests, stdenv, ... } @ args:

buildLinux (args // rec {
  version = "4.9.277";
  extraMeta.branch = "4.9";
  extraMeta.broken = stdenv.isAarch64;

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1pkjcz9llc7hkmzfyjcx20b5njnqbkwlzyy1ncc8na71nn6rvsg6";
  };

  kernelTests = args.kernelTests or [ nixosTests.kernel-generic.linux_4_9 ];
} // (args.argsOverride or {}))
