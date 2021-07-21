{ lib, buildPackages, fetchurl, perl, buildLinux, nixosTests, modDirVersionArg ? null, ... } @ args:

with lib;

buildLinux (args // rec {
  version = "5.13.4";

  # modDirVersion needs to be x.y.z, will automatically add .0 if needed
  modDirVersion = if (modDirVersionArg == null) then concatStringsSep "." (take 3 (splitVersion "${version}.0")) else modDirVersionArg;

  # branchVersion needs to be x.y
  extraMeta.branch = versions.majorMinor version;

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v5.x/linux-${version}.tar.xz";
    sha256 = "0v3x1q1r0r8lyjg5hsj7yayfxqcgfj01p86ya4s0i9jaclpwv4ki";
  };

  kernelTests = args.kernelTests or [ nixosTests.kernel-generic.linux_5_13 ];
} // (args.argsOverride or { }))

