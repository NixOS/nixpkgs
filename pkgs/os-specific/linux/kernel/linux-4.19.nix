{ lib, buildPackages, fetchurl, perl, buildLinux, nixosTests, ... } @ args:

buildLinux (args // rec {
  version = "4.19.269";

  # modDirVersion needs to be x.y.z, will automatically add .0 if needed
  modDirVersion = lib.versions.pad 3 version;

  # branchVersion needs to be x.y
  extraMeta.branch = lib.versions.majorMinor version;

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "02mjb16xxfj984vibpxvhjl84y5yg0jgzjccjdxnn8db4k9aa2vf";
  };
} // (args.argsOverride or {}))
