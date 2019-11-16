{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.202";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0adrmps7izfqy0yn4440isxvigslwzk1a375r9kh86idwbmcxb7x";
  };
} // (args.argsOverride or {}))
