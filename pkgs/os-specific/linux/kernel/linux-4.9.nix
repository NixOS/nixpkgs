{ buildPackages, fetchurl, perl, buildLinux, nixosTests, stdenv, ... } @ args:

buildLinux (args // rec {
  version = "4.9.279";
  extraMeta.branch = "4.9";
  extraMeta.broken = stdenv.isAarch64;

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "01rf3xh2jcz6l2h79g0m02i8f9q51j64wvgvzi8lmq0gx9yvbv91";
  };

  kernelTests = args.kernelTests or [ nixosTests.kernel-generic.linux_4_9 ];
} // (args.argsOverride or {}))
