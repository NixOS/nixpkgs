{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.242";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1r1myvxkhnsz419i5y6zjdkz177q3d19jk7748vv1v505gi3k1g4";
  };
} // (args.argsOverride or {}))
