{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.246";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "15xd1dqw53kwqvsa71nr1ymp0jp22pkl4h2yks4hqbd132zxw2wy";
  };
} // (args.argsOverride or {}))
