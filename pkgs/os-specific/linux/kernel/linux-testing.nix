{ lib, buildPackages, fetchurl, perl, buildLinux, nixosTests, ... } @ args:

buildLinux (args // rec {
  version = "6.2-rc2";
  extraMeta.branch = lib.versions.majorMinor version;

  # modDirVersion needs to be x.y.z, will always add .0
  modDirVersion = lib.versions.pad 3 version;

  src = fetchurl {
    url = "https://git.kernel.org/torvalds/t/linux-${version}.tar.gz";
    hash = "sha256-QRmOwtoGG2uNCNcAIAltrCT7zaD2V+RNe3bjHGn5+ts=";
  };

  # Should the testing kernels ever be built on Hydra?
  extraMeta.hydraPlatforms = [];

} // (args.argsOverride or {}))
