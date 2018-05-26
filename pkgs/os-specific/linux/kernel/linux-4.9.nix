{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.102";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1icx253l8s158d1ccn594ddkqdxch8jr0w6kbj00jn1dlmms6mfi";
  };
} // (args.argsOverride or {}))
