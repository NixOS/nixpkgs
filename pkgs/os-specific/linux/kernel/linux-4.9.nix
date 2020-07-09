{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.230";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0z03djys7k3z6z55xrw8rj4mv5i4h763lckz2anwxwgbwdb95fnm";
  };
} // (args.argsOverride or {}))
