{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.227";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0pqc0wld4s4zjas95xm54mrkk00l9zkc59b6i9gq4km126s8bi1q";
  };
} // (args.argsOverride or {}))
