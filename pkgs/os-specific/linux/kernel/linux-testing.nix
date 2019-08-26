{ stdenv, buildPackages, fetchurl, perl, buildLinux, modDirVersionArg ? null, ... } @ args:

with stdenv.lib;

buildLinux (args // rec {
  version = "5.3-rc6";
  extraMeta.branch = "5.3";

  # modDirVersion needs to be x.y.z, will always add .0
  modDirVersion = if (modDirVersionArg == null) then builtins.replaceStrings ["-"] [".0-"] version else modDirVersionArg;

  src = fetchurl {
    url = "https://git.kernel.org/torvalds/t/linux-${version}.tar.gz";
    sha256 = "0q6h4hr42bi6cj8vi3g2v4yqj7x8rz8npz8sr2lxh0gy35akjdig";
  };

  # Should the testing kernels ever be built on Hydra?
  extraMeta.hydraPlatforms = [];

  # Testing kernels are not maintained on stable releases
  extraMeta.broken = true;

} // (args.argsOverride or {}))
