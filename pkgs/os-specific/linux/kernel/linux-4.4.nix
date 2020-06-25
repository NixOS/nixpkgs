{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.228";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0y1xc5lk8j3p5maarksmh18wy921rgcngzsih7q1a82rah1fsjxr";
  };
} // (args.argsOverride or {}))
