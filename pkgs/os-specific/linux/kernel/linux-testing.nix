{ stdenv, buildPackages, fetchurl, perl, buildLinux, libelf, utillinux, ... } @ args:

buildLinux (args // rec {
  version = "5.0-rc2";
  modDirVersion = "5.0.0-rc2";
  extraMeta.branch = "5.0";

  src = fetchurl {
    url = "https://git.kernel.org/torvalds/t/linux-${version}.tar.gz";
    sha256 = "1204b15gkdb7hxaqx1x7kxn48p1gl8gl51vgifxn2saikzlzls7c";
  };

  # Should the testing kernels ever be built on Hydra?
  extraMeta.hydraPlatforms = [];

} // (args.argsOverride or {}))
