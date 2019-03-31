{ stdenv, buildPackages, fetchurl, perl, buildLinux, libelf, utillinux, ... } @ args:

buildLinux (args // rec {
  version = "5.1-rc2";
  modDirVersion = "5.1.0-rc2";
  extraMeta.branch = "5.1";

  src = fetchurl {
    url = "https://git.kernel.org/torvalds/t/linux-${version}.tar.gz";
    sha256 = "10x6d550cqyj7ipn2q13m03x5vnwv90wgs6532r8fnd86rkygmqb";
  };

  # Should the testing kernels ever be built on Hydra?
  extraMeta.hydraPlatforms = [];

} // (args.argsOverride or {}))
