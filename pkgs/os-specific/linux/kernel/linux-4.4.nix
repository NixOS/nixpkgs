{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.155";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1nbd88x3m4w2ffwgjnf8ry5p2z7al54q1lvl2kv3fz8hmr5qq28q";
  };
} // (args.argsOverride or {}))
