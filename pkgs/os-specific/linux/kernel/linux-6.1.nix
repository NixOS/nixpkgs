{ lib, buildPackages, fetchurl, perl, buildLinux, nixosTests, ... } @ args:

buildLinux (args // rec {
  version = "6.1.6";

  # modDirVersion needs to be x.y.z, will automatically add .0 if needed
  modDirVersion = lib.versions.pad 3 version;

  # branchVersion needs to be x.y
  extraMeta.branch = lib.versions.majorMinor version;

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v6.x/linux-${version}.tar.xz";
    sha256 = "1qsygnsn67j843ywpswy5724zin5sszb5mz8b8h3lw553mb8wk9y";
  };
} // (args.argsOverride or { }))
