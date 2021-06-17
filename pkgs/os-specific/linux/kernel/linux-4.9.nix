{ buildPackages, fetchurl, perl, buildLinux, nixosTests, stdenv, ... } @ args:

buildLinux (args // rec {
  version = "4.9.273";
  extraMeta.branch = "4.9";
  extraMeta.broken = stdenv.isAarch64;

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0jjarv3xfkc21j1xhgch53w8wm6rq3xw1i03rjw9fv5i9k4x6qsw";
  };

  kernelTests = args.kernelTests or [ nixosTests.kernel-generic.linux_4_9 ];
} // (args.argsOverride or {}))
