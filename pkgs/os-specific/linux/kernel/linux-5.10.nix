{ lib, buildPackages, fetchurl, perl, buildLinux, nixosTests, modDirVersionArg ? null, ... } @ args:

with lib;

buildLinux (args // rec {
  version = "5.10.33";

  # modDirVersion needs to be x.y.z, will automatically add .0 if needed
  modDirVersion = if (modDirVersionArg == null) then concatStringsSep "." (take 3 (splitVersion "${version}.0")) else modDirVersionArg;

  # branchVersion needs to be x.y
  extraMeta.branch = versions.majorMinor version;

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v5.x/linux-${version}.tar.xz";
    sha256 = "05a3bcc6ic9gyhp8bahfrk8xm8pwb6jmgad6nwqgih3icg1xngwk";
  };

  kernelTests = args.kernelTests or [ nixosTests.kernel-generic.linux_5_10 ];
} // (args.argsOverride or {}))
