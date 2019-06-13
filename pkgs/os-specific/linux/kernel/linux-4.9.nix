{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.181";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1vgwfjsn31fy0ikcnpaqbw8w0r0xb25xp3633f0258yb24z25kcg";
  };
} // (args.argsOverride or {}))
