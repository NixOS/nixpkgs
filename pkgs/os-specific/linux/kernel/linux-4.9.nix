{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.99";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1pqk88h8wyqz2ijp0pav1b35m2hs9d9is1kcir649jlbj66fphrx";
  };
} // (args.argsOverride or {}))
