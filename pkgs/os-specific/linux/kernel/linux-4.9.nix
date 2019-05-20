{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.177";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1vl7g21538ndlygpjsbjnayi9f37zi8s2g37gcznany3phz1wfy7";
  };
} // (args.argsOverride or {}))
