{ stdenv, buildPackages, fetchurl, perl, buildLinux, modDirVersionArg ? null, ... } @ args:

with stdenv.lib;

buildLinux (args // rec {
  version = "5.4-rc2";
  extraMeta.branch = "5.4";

  # modDirVersion needs to be x.y.z, will always add .0
  modDirVersion = if (modDirVersionArg == null) then builtins.replaceStrings ["-"] [".0-"] version else modDirVersionArg;

  src = fetchurl {
    url = "https://git.kernel.org/torvalds/t/linux-${version}.tar.gz";
    sha256 = "0dnn771wydwc4sngy9a3szvflbw9g97ann4iix4k4bq4gr18jw2c";
  };

  # Should the testing kernels ever be built on Hydra?
  extraMeta.hydraPlatforms = [];

} // (args.argsOverride or {}))
