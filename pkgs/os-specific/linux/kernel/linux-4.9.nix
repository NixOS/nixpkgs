{ buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.254";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1djw5mlff73j7m1176qspdzhf6zyv4m0gkdvlxq4g4mdrbqfx6xn";
  };
} // (args.argsOverride or {}))
