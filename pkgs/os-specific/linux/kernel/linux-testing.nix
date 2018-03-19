{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, libelf, utillinux, ... } @ args:

buildLinux (args // rec {
  version = "4.16-rc5";
  modDirVersion = "4.16.0-rc5";
  extraMeta.branch = "4.16";

  src = fetchurl {
    url = "https://git.kernel.org/torvalds/t/linux-${version}.tar.gz";
    sha256 = "0yfa0qrs6fwh88xgn252j7nc8q4x5qhf20dlax9hcnza0ai6nk3z";
  };

  # Should the testing kernels ever be built on Hydra?
  extraMeta.hydraPlatforms = [];

} // (args.argsOverride or {}))
