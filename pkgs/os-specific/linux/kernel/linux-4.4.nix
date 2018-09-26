{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.158";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1a921xq475y961izkzn8n4ky9s7n4xsvhs9qh664xk5biip8y72p";
  };
} // (args.argsOverride or {}))
