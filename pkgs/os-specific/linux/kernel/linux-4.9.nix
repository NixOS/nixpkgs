{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.199";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1mby7ymcx6f9phacbaq2n9rr0rfv0r2dis2lk7j0wclfj3q3298g";
  };
} // (args.argsOverride or {}))
