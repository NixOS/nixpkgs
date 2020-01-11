{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.208";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "03jj91z5dc0ybpjy9w6aanb3k53gcj7gsjc32h3ldf72hlmgz6aq";
  };
} // (args.argsOverride or {}))
