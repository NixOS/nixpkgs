{ lib, buildPackages, fetchurl, perl, buildLinux, nixosTests, ... } @ args:

with lib;

buildLinux (args // rec {
<<<<<<< HEAD
  version = "5.4.256";
=======
  version = "5.4.242";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # modDirVersion needs to be x.y.z, will automatically add .0 if needed
  modDirVersion = versions.pad 3 version;

  # branchVersion needs to be x.y
  extraMeta.branch = versions.majorMinor version;

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v5.x/linux-${version}.tar.xz";
<<<<<<< HEAD
    sha256 = "0fim5q9xakwnjfg48bpsic9r2r8dvrjlalqqkm9vh1rml9mhi967";
=======
    sha256 = "0a7wfi84p74qsnbj1vamz4qxzp94v054jp1csyfl0blz3knrlbql";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
} // (args.argsOverride or {}))
