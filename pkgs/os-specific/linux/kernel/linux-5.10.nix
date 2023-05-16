{ lib, buildPackages, fetchurl, perl, buildLinux, nixosTests, ... } @ args:

with lib;

buildLinux (args // rec {
<<<<<<< HEAD
  version = "5.10.194";
=======
  version = "5.10.179";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # modDirVersion needs to be x.y.z, will automatically add .0 if needed
  modDirVersion = versions.pad 3 version;

  # branchVersion needs to be x.y
  extraMeta.branch = versions.majorMinor version;

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v5.x/linux-${version}.tar.xz";
<<<<<<< HEAD
    sha256 = "15fr7krhpmqz0xqjg78m2xvfllbni3xh8xyhxh9ni31ppd3mw394";
=======
    sha256 = "0abylcqbzpxxh45kmvd9i2cig64aajz87j5c8vm3w1ab2mf49g8v";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
} // (args.argsOverride or {}))
