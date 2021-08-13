{ buildPackages, fetchurl, perl, buildLinux, nixosTests, stdenv, ... } @ args:

buildLinux (args // rec {
  version = "4.4.279";
  extraMeta.branch = "4.4";
  extraMeta.broken = stdenv.isAarch64;

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1d3cfhs7ixk0dhh1mc1z6y73i816a2wl16zhayl1ssp69d4ndpsb";
  };

  kernelTests = args.kernelTests or [ nixosTests.kernel-generic.linux_4_4 ];
} // (args.argsOverride or {}))
