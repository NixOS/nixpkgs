{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.109";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1c2rwddr8v1l0b5yswfmpy0pf4gdqi4ycs9b94cj2hsklma5dk9x";
  };
} // (args.argsOverride or {}))
