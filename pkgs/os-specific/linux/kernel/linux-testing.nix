{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, libelf, utillinux, ... } @ args:

buildLinux (args // rec {
  version = "4.17-rc6";
  modDirVersion = "4.17.0-rc6";
  extraMeta.branch = "4.17";

  src = fetchurl {
    url = "https://git.kernel.org/torvalds/t/linux-${version}.tar.gz";
    sha256 = "16x8bwhaj35fqhl773qxwabs1rhl3ayapizjsqyzn92pggsgy6p8";
  };

  # Should the testing kernels ever be built on Hydra?
  extraMeta.hydraPlatforms = [];

} // (args.argsOverride or {}))
