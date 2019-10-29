{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.198";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "04pkryy1lc75c88vq5wcjjcxs43i7bb8hhplbfi6s204ipc0iy7c";
  };
} // (args.argsOverride or {}))
