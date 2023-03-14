{ lib, buildPackages, fetchurl, perl, buildLinux, nixosTests, ... } @ args:

with lib;

buildLinux (args // rec {
  version = "5.10.174";

  # modDirVersion needs to be x.y.z, will automatically add .0 if needed
  modDirVersion = versions.pad 3 version;

  # branchVersion needs to be x.y
  extraMeta.branch = versions.majorMinor version;

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v5.x/linux-${version}.tar.xz";
    sha256 = "092ai8ggplsa933s3qlayyjkw9d3z6sg782byh7rz0ym0380r2ig";
  };
} // (args.argsOverride or {}))
