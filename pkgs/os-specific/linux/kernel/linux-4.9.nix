{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.84";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1dqvmxy152zymfpvrpxrd85hs1481b814p84a5dbgs1cfs4nrf3c";
  };
} // (args.argsOverride or {}))
