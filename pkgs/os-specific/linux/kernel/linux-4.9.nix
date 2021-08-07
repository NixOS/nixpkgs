{ buildPackages, fetchurl, perl, buildLinux, nixosTests, stdenv, ... } @ args:

buildLinux (args // rec {
  version = "4.9.278";
  extraMeta.branch = "4.9";
  extraMeta.broken = stdenv.isAarch64;

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "04byav6cbga3jqkppygm5zj73d9v44xyvx6hbrhwr22lsk282dz7";
  };

  kernelTests = args.kernelTests or [ nixosTests.kernel-generic.linux_4_9 ];
} // (args.argsOverride or {}))
