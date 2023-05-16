{ lib, buildPackages, fetchurl, perl, buildLinux, nixosTests, ... } @ args:

with lib;

buildLinux (args // rec {
<<<<<<< HEAD
  version = "4.14.325";
=======
  version = "4.14.314";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # modDirVersion needs to be x.y.z, will automatically add .0 if needed
  modDirVersion = versions.pad 3 version;

  # branchVersion needs to be x.y
  extraMeta.branch = versions.majorMinor version;

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
<<<<<<< HEAD
    sha256 = "117p1mdha57f6d3kdwac9jrbmib7g77q4xhir8ghl6fmrs1f2sav";
=======
    sha256 = "0lwiykv2ci7lrjvvykbiqavzzizdkf8xxqlybixi9l1as7q02v47";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
} // (args.argsOverride or {}))
