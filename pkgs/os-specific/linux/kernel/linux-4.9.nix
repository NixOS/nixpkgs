{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.9.78";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1wy02y9nkwsi3bbcg5w4jzxp3f7aalylh1gh79bzi4knysz4zlfj";
  };
} // (args.argsOverride or {}))
