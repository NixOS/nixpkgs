{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.232";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0q2gpkazfw93r79aq21kv1y3hwxawl0swyvd3nd73p254gl75x2q";
  };
} // (args.argsOverride or {}))
