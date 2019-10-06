{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.195";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1dilaz0ghmkml10cvzzpz7ivcx9d8d6fpb76vmixcg634w2jx962";
  };
} // (args.argsOverride or {}))
