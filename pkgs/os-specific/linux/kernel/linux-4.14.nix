{ lib, buildPackages, fetchurl, perl, buildLinux, nixosTests, ... } @ args:

buildLinux (args // rec {
  version = "4.14.302";

  # modDirVersion needs to be x.y.z, will automatically add .0 if needed
  modDirVersion = lib.versions.pad 3 version;

  # branchVersion needs to be x.y
  extraMeta.branch = lib.versions.majorMinor version;

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "102c9h0byr9v4bxzkdh7mnw1grm47ji6lf6l1gjlwah7f46j6ap3";
  };
} // (args.argsOverride or {}))
