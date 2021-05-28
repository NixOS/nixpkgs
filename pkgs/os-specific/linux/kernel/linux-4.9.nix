{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.239";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0lfbn5amykvwz1svvxayzhsz1dvm4mgzsnq1g0wqffclxm148hr3";
  };
} // (args.argsOverride or {}))
