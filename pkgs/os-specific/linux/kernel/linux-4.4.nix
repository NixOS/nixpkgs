{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.144";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "11lsf62qd9qm6n6ilxwx0zag3phvfmfjpbdc24j4p2c9gfgqpyss";
  };
} // (args.argsOverride or {}))
