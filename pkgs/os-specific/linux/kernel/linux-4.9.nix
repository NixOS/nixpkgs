{ buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.261";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0r5822mj2gk9s8rbc8bazg34y8bwr7svn3nbgcq57y2qch8nych4";
  };
} // (args.argsOverride or {}))
