{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.138";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1dr1mf7i1mwy780048gkhvy283j8331xwgrs2x5qal0xc1114c4j";
  };
} // (args.argsOverride or {}))
