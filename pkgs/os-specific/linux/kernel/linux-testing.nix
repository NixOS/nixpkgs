{ stdenv, buildPackages, fetchurl, perl, buildLinux, modDirVersionArg ? null, ... } @ args:

with stdenv.lib;

buildLinux (args // rec {
  version = "5.3-rc5";
  extraMeta.branch = "5.3";

  # modDirVersion needs to be x.y.z, will always add .0
  modDirVersion = if (modDirVersionArg == null) then builtins.replaceStrings ["-"] [".0-"] version else modDirVersionArg;

  src = fetchurl {
    url = "https://git.kernel.org/torvalds/t/linux-${version}.tar.gz";
    sha256 = "1hsmd53fn1irv7w0z84i3rqdi497p1hsazasjv4g3bj1s9qcqjbp";
  };

  # Should the testing kernels ever be built on Hydra?
  extraMeta.hydraPlatforms = [];

  # Testing kernels are not maintained on stable releases
  extraMeta.broken = true;

} // (args.argsOverride or {}))
