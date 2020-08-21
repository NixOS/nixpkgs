{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.233";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1z77dikgkvkp9ggwxp07hl8vxsf9kq57rhfdpbvhny1x13fqkrlp";
  };
} // (args.argsOverride or {}))
