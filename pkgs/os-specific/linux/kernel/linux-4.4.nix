{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.162";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0l2agmxzmq89jbh7r00qg4msvmhny40m2jar96fibwpklwd44kki";
  };
} // (args.argsOverride or {}))
