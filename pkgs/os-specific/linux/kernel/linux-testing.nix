{ stdenv, buildPackages, fetchurl, perl, buildLinux, modDirVersionArg ? null, ... } @ args:

with stdenv.lib;

buildLinux (args // rec {
  version = "5.5-rc2";
  extraMeta.branch = "5.5";

  # modDirVersion needs to be x.y.z, will always add .0
  modDirVersion = if (modDirVersionArg == null) then builtins.replaceStrings ["-"] [".0-"] version else modDirVersionArg;

  src = fetchurl {
    url = "https://git.kernel.org/torvalds/t/linux-${version}.tar.gz";
    sha256 = "1fs432ld5k1j68hflqdxby9mxa6a7xnw1m6z5lfb9341gjw078xc";
  };

  # Should the testing kernels ever be built on Hydra?
  extraMeta.hydraPlatforms = [];

} // (args.argsOverride or {}))
