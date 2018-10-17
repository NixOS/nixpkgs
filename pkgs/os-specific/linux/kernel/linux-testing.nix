{ stdenv, buildPackages, fetchurl, perl, buildLinux, libelf, utillinux, ... } @ args:

buildLinux (args // rec {
  version = "4.19-rc8";
  modDirVersion = "4.19.0-rc8";
  extraMeta.branch = "4.19";

  src = fetchurl {
    url = "https://git.kernel.org/torvalds/t/linux-${version}.tar.gz";
    sha256 = "1xw8grzn4i4b2vprfwi4p4003n7rr9725dbiqyrl8w1pm11jwpin";
  };

  # Should the testing kernels ever be built on Hydra?
  extraMeta.hydraPlatforms = [];

} // (args.argsOverride or {}))
