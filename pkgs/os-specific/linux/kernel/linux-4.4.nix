{ buildPackages, fetchurl, perl, buildLinux, nixosTests, stdenv, ... } @ args:

buildLinux (args // rec {
  version = "4.4.268";
  extraMeta.branch = "4.4";
  extraMeta.broken = stdenv.isAarch64;

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1srk08kaxq5jjlqx804cgjffhcsrdkv3idh8ipagl6v2w4kas5v8";
  };

  kernelTests = args.kernelTests or [ nixosTests.kernel-generic.linux_4_4 ];
} // (args.argsOverride or {}))
