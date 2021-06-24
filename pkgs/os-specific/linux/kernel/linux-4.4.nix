{ buildPackages, fetchurl, perl, buildLinux, nixosTests, ... } @ args:

buildLinux (args // rec {
  version = "4.4.266";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "00x2dmjiiv9zpc0vih9xqmf78kynqzj9q9v1chc2q2hcjpqfj31c";
  };

  kernelTests = args.kernelTests or [ nixosTests.kernel-generic.linux_4_4 ];
} // (args.argsOverride or {}))
