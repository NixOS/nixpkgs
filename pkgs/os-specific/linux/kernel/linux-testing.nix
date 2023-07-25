{ lib, buildPackages, fetchzip, perl, buildLinux, nixosTests, ... } @ args:

with lib;

buildLinux (args // rec {
  version = "6.4-rc7";
  extraMeta.branch = lib.versions.majorMinor version;

  # modDirVersion needs to be x.y.z, will always add .0
  modDirVersion = versions.pad 3 version;

  src = fetchzip {
    url = "https://git.kernel.org/torvalds/t/linux-${version}.tar.gz";
    hash = "sha256-UDhLrKe8yMvmWbS19Xt1G3SQpAUWyKrfV3v1MJ5Vep8=";
  };

  # Should the testing kernels ever be built on Hydra?
  extraMeta.hydraPlatforms = [];

} // (args.argsOverride or {}))
