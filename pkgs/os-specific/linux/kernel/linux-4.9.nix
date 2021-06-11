{ buildPackages, fetchurl, perl, buildLinux, nixosTests, stdenv, ... } @ args:

buildLinux (args // rec {
  version = "4.9.271";
  extraMeta.branch = "4.9";
  extraMeta.broken = stdenv.isAarch64;

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1480miixphkf0b8w00m753ar7yp1rnl3zyr9wp4inngi2f90553r";
  };

  kernelTests = args.kernelTests or [ nixosTests.kernel-generic.linux_4_9 ];
} // (args.argsOverride or {}))
