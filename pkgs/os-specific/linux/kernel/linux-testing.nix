{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, libelf, utillinux, ... } @ args:

buildLinux (args // rec {
  version = "4.17-rc2";
  modDirVersion = "4.17.0-rc2";
  extraMeta.branch = "4.17";

  src = fetchurl {
    url = "https://git.kernel.org/torvalds/t/linux-${version}.tar.gz";
    sha256 = "1z4kl25x8m498wicbzhx21kvksp63ab8l2s0nfxf7fwj7dd13cld";
  };

  # Should the testing kernels ever be built on Hydra?
  extraMeta.hydraPlatforms = [];

} // (args.argsOverride or {}))
