{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.195";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0s4xj8f1dpnz3fbrqmgwq02smhcrq1ni8hgn2bbfqvm15lm5dgjl";
  };
} // (args.argsOverride or {}))
