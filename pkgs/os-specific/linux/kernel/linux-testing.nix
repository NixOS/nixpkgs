{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, libelf, utillinux, ... } @ args:

buildLinux (args // rec {
  version = "4.16-rc4";
  modDirVersion = "4.16.0-rc4";
  extraMeta.branch = "4.16";

  src = fetchurl {
    url = "https://git.kernel.org/torvalds/t/linux-${version}.tar.gz";
    sha256 = "0fxs3i7rdw5mybmim0npmzqpp7i3ppy1f6f72q2w3qdbjmbqm7w6";
  };

  # Should the testing kernels ever be built on Hydra?
  extraMeta.hydraPlatforms = [];

} // (args.argsOverride or {}))
