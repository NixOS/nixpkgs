{ lib, buildPackages, fetchurl, perl, buildLinux, nixosTests, ... } @ args:

with lib;

buildLinux (args // rec {
<<<<<<< HEAD
  version = "4.19.294";
=======
  version = "4.19.282";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # modDirVersion needs to be x.y.z, will automatically add .0 if needed
  modDirVersion = versions.pad 3 version;

  # branchVersion needs to be x.y
  extraMeta.branch = versions.majorMinor version;

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
<<<<<<< HEAD
    sha256 = "03x0xsb8a369zdr81hg6xdl5n5v48k6iwnhj6r29725777lvvbfc";
=======
    sha256 = "02z20879xl4ya957by1p35vi1a7myzxwiqd9cnvm541sgnci99a3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
} // (args.argsOverride or {}))
