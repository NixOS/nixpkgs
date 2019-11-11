{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.200";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "02g8h62nq0xrfkxfxxwamdnmkw19p2x5lnrmqszlvgx1ymhfsnfm";
  };
} // (args.argsOverride or {}))
