{ lib, buildPackages, fetchzip, perl, buildLinux, nixosTests, ... } @ args:

with lib;

buildLinux (args // rec {
  version = "6.6-rc1";
  extraMeta.branch = lib.versions.majorMinor version;

  # modDirVersion needs to be x.y.z, will always add .0
  modDirVersion = versions.pad 3 version;

  src = fetchzip {
    url = "https://git.kernel.org/torvalds/t/linux-${version}.tar.gz";
    hash = "sha256-DRai7HhWVtRB0GiRCvCv2JM2TFKRsZ60ohD6GW0b8As=";
  };

  # Should the testing kernels ever be built on Hydra?
  extraMeta.hydraPlatforms = [];

} // (args.argsOverride or {}))
