{ lib, buildPackages, fetchzip, perl, buildLinux, nixosTests, ... } @ args:

with lib;

buildLinux (args // rec {
<<<<<<< HEAD
  version = "6.6-rc1";
=======
  version = "6.4-rc1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  extraMeta.branch = lib.versions.majorMinor version;

  # modDirVersion needs to be x.y.z, will always add .0
  modDirVersion = versions.pad 3 version;

  src = fetchzip {
    url = "https://git.kernel.org/torvalds/t/linux-${version}.tar.gz";
<<<<<<< HEAD
    hash = "sha256-DRai7HhWVtRB0GiRCvCv2JM2TFKRsZ60ohD6GW0b8As=";
=======
    hash = "sha256-ayKzQNYfm8UjGZc8fy6sJF8xnkTxCCKpDv2TwdtKuKo=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  # Should the testing kernels ever be built on Hydra?
  extraMeta.hydraPlatforms = [];

} // (args.argsOverride or {}))
