{ buildPackages, fetchurl, perl, buildLinux, nixosTests, ... } @ args:

buildLinux (args // rec {
  version = "4.4.267";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1qk629fsl1glr0h1hxami3f4ivgl58iqsnw43slvn1yc91cb7ws4";
  };

  kernelTests = args.kernelTests or [ nixosTests.kernel-generic.linux_4_4 ];
} // (args.argsOverride or {}))
