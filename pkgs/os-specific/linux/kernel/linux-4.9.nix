{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.143";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1grcmh85n6ya8h2v0qx2pxryjxx3501kjbknz3a5yrwnlrj69dqf";
  };
} // (args.argsOverride or {}))
