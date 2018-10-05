{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.131";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0q2xmbkh42ikw26bdxgk1f9192hygyq9ffkhjfpr0fcx8sak5nsp";
  };
} // (args.argsOverride or {}))
