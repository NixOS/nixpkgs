{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, libelf, utillinux, ... } @ args:

buildLinux (args // rec {
  version = "4.18-rc4";
  modDirVersion = "4.18.0-rc4";
  extraMeta.branch = "4.18";

  src = fetchurl {
    url = "https://git.kernel.org/torvalds/t/linux-${version}.tar.gz";
    sha256 = "1nhl82ygz7sm6njnb9qg9k4jp0gr1cv2wxpayrpc4ab21xb6b5mj";
  };

  # Should the testing kernels ever be built on Hydra?
  extraMeta.hydraPlatforms = [];

} // (args.argsOverride or {}))
