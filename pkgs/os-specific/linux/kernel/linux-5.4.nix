{ lib, buildPackages, fetchurl, perl, buildLinux, nixosTests, ... } @ args:

with lib;

buildLinux (args // rec {
  version = "5.4.255";

  # modDirVersion needs to be x.y.z, will automatically add .0 if needed
  modDirVersion = versions.pad 3 version;

  # branchVersion needs to be x.y
  extraMeta.branch = versions.majorMinor version;

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v5.x/linux-${version}.tar.xz";
    sha256 = "0qd0lil0k4kd2qp4by8i861n19iz1pdvimnmp4khzna75y8fvm9l";
  };
} // (args.argsOverride or {}))
