{ buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.258";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0rb6sww4yd2m4a4v12klx29nyxb66f55ziv8xcihgf2iw4d62h8c";
  };
} // (args.argsOverride or {}))
