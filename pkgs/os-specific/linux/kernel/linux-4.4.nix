{ buildPackages, fetchurl, perl, buildLinux, nixosTests, stdenv, ... } @ args:

buildLinux (args // rec {
  version = "4.4.296";
  extraMeta.branch = "4.4";
  extraMeta.broken = stdenv.isAarch64;

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1ydh6qiib6anxv5kxd13d9p2hjh3ni7r3whxazlzvckijmzqd5nb";
  };
} // (args.argsOverride or {}))
