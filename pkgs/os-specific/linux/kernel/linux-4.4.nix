{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.196";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0vd7fra22ky4sqp6vamracp5xd4900md5vdx0n4i6dhkf03kz7hn";
  };
} // (args.argsOverride or {}))
