{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.225";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0pn66hf9yrjg15skq1inscr5m0slvgsd2qm8rg5id70llrb4jis9";
  };
} // (args.argsOverride or {}))
