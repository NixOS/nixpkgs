{ lib, buildPackages, fetchurl, perl, buildLinux, nixosTests, modDirVersionArg ? null, ... } @ args:

with lib;

buildLinux (args // rec {
  version = "5.10.159";

  # modDirVersion needs to be x.y.z, will automatically add .0 if needed
  modDirVersion = versions.pad 3 version;

  # branchVersion needs to be x.y
  extraMeta.branch = versions.majorMinor version;

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v5.x/linux-${version}.tar.xz";
    sha256 = "19yfi5vknxnw0cb8274q3pb5zjs6ny04n16m8xjdfdmznrbvza8v";
  };
} // (args.argsOverride or {}))
  // lib.optionalAttrs (modDirVersionArg != null) { modDirVersion = modDirVersionArg; } # legacy
