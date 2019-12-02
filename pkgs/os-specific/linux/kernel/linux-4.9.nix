{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.205";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "01cbqxw77g6rdg7dgk73pg9a2n9v4sxp48q2a77w1b068xjfifcq";
  };
} // (args.argsOverride or {}))
