{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.193";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "13iy0xyrqqagnrk7msp1qfw6xsc0dlc74dpdzki9rfsxcildxz3a";
  };
} // (args.argsOverride or {}))
