{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.246";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1xd9vgc4yj2vrr5r76cy3fp9a1fc3086lj5aws68wf1dsz3ndqj9";
  };
} // (args.argsOverride or {}))
