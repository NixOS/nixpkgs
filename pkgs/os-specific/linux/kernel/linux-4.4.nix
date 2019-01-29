{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.171";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "187g9x2zd738s1ric8zl205b7xipvr0l5i045clnhqwl5bd78h7x";
  };
} // (args.argsOverride or {}))
