{ lib, buildPackages, fetchzip, perl, buildLinux, nixosTests, ... } @ args:

with lib;

buildLinux (args // rec {
  version = "6.3-rc7";
  extraMeta.branch = lib.versions.majorMinor version;

  # modDirVersion needs to be x.y.z, will always add .0
  modDirVersion = versions.pad 3 version;

  src = fetchzip {
    url = "https://git.kernel.org/torvalds/t/linux-${version}.tar.gz";
    hash = "sha256-fCfjWJlFN3YZPRmvO1sL1kcYj+dSSuj+n00qowUZ9GI=";
  };

  # Should the testing kernels ever be built on Hydra?
  extraMeta.hydraPlatforms = [];

} // (args.argsOverride or {}))
