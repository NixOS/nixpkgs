{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

with stdenv.lib;

buildLinux (args // rec {
  version = "4.14.26";

  # branchVersion needs to be x.y
  extraMeta.branch = concatStrings (intersperse "." (take 2 (splitString "." version)));

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0n3ckh77n81jfgrivhxz17fm2l3mi5yicjg19sc7n0318b2nd94r";
  };
} // (args.argsOverride or {}))
