{ lib, buildPackages, fetchurl, perl, buildLinux, nixosTests, modDirVersionArg ? null, ... } @ args:

with lib;

buildLinux (args // rec {
  version = "5.10.52";

  # modDirVersion needs to be x.y.z, will automatically add .0 if needed
  modDirVersion = if (modDirVersionArg == null) then concatStringsSep "." (take 3 (splitVersion "${version}.0")) else modDirVersionArg;

  # branchVersion needs to be x.y
  extraMeta.branch = versions.majorMinor version;

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v5.x/linux-${version}.tar.xz";
    sha256 = "0ydf09wsg0pkjm9dk8y730ksg15p5rlbhq445zx8k191zah5g7kn";
  };

  kernelTests = args.kernelTests or [ nixosTests.kernel-generic.linux_5_10 ];
} // (args.argsOverride or {}))
