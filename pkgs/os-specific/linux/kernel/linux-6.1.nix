{ lib, buildPackages, fetchurl, perl, buildLinux, nixosTests, ... } @ args:

with lib;

buildLinux (args // rec {
<<<<<<< HEAD
  version = "6.1.52";
=======
  version = "6.1.28";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # modDirVersion needs to be x.y.z, will automatically add .0 if needed
  modDirVersion = versions.pad 3 version;

  # branchVersion needs to be x.y
  extraMeta.branch = versions.majorMinor version;

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v6.x/linux-${version}.tar.xz";
<<<<<<< HEAD
    sha256 = "0lis73mxnl7hxz8lyja6sfgmbym944l3k1h7dab6b4mw1nckfxsn";
=======
    sha256 = "1w56qgf1vgk3dmh4xw6699kjm5pdqvyfzr19ah5yy3xj50a4q2bs";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
} // (args.argsOverride or { }))
