{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.133";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0qv5n8vipkqcd0hpf5l41h023n46rgja39h895phlcxs4p00ywsk";
  };
} // (args.argsOverride or {}))
