{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.117";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1c3r0a4fchg358zff2ww8kw789kah3bhr750p9qlsy65d8rflcl2";
  };
} // (args.argsOverride or {}))
