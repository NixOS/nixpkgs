{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.270";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0ck5abzpla291gcxrxjindj5szgcvmb2fwfilvdnzc6pnqk00ay3";
  };
} // (args.argsOverride or {}))
