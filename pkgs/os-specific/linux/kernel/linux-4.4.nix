{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.129";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0aviyky8f73l6jpi1d4by947rj78d5vckxkyf9aj73bavaxc8rd1";
  };
} // (args.argsOverride or {}))
