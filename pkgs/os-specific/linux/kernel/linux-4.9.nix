{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.225";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1s63aymgsc4lsysy9d972ps9cyrf6bncyy5wcpv5a3wbaj678iz5";
  };
} // (args.argsOverride or {}))
