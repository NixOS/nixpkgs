{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, libre ? false, ... } @ args:

with stdenv.lib;

buildLinux (args // rec {
  version = "4.14.26" + (if libre then "-gnu" else "");

  # branchVersion needs to be x.y
  extraMeta.branch = concatStrings (intersperse "." (take 2 (splitString "." version)));

  src = fetchurl {
    url = if !libre
          then "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz"
          else "https://www.linux-libre.fsfla.org/pub/linux-libre/releases/${version}/linux-libre-${version}.tar.xz";
    sha256 = if !libre
             then "0n3ckh77n81jfgrivhxz17fm2l3mi5yicjg19sc7n0318b2nd94r"
             else "1m2zr17wpasg5riysbaa4g5i492jzr93py2jm088ki818s4a9cm3";
  };
} // (args.argsOverride or {}))
