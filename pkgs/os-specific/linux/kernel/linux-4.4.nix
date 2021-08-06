{ buildPackages, fetchurl, perl, buildLinux, nixosTests, stdenv, ... } @ args:

buildLinux (args // rec {
  version = "4.4.278";
  extraMeta.branch = "4.4";
  extraMeta.broken = stdenv.isAarch64;

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1r2sbxn8finzcg72ds5dyh4578vv2s5zwylq3b3xyw3hzr4swn4f";
  };

  kernelTests = args.kernelTests or [ nixosTests.kernel-generic.linux_4_4 ];
} // (args.argsOverride or {}))
