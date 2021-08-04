{ buildPackages, fetchurl, perl, buildLinux, nixosTests, stdenv, ... } @ args:

buildLinux (args // rec {
  version = "4.4.277";
  extraMeta.branch = "4.4";
  extraMeta.broken = stdenv.isAarch64;

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1m5zkssh523f15fvy80rcvfwqzdkldz3jhny6vbaj8q0zvk3w5r5";
  };

  kernelTests = args.kernelTests or [ nixosTests.kernel-generic.linux_4_4 ];
} // (args.argsOverride or {}))
