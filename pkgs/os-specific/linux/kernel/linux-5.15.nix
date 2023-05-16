{ lib, buildPackages, fetchurl, perl, buildLinux, nixosTests, ... } @ args:

with lib;

buildLinux (args // rec {
<<<<<<< HEAD
  version = "5.15.131";
=======
  version = "5.15.111";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # modDirVersion needs to be x.y.z, will automatically add .0 if needed
  modDirVersion = versions.pad 3 version;

  # branchVersion needs to be x.y
  extraMeta.branch = versions.majorMinor version;

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v5.x/linux-${version}.tar.xz";
<<<<<<< HEAD
    sha256 = "0sacnbw48lblnqaj56nybh588sq4k84gwf0r5zinzyrryj8k6z4r";
=======
    sha256 = "1hmfvii77w70dx1lsfigc7nmjblvs1q131q48didsn01khjymkkp";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
} // (args.argsOverride or { }))
