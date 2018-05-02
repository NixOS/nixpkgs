{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

with stdenv.lib;

buildLinux (args // rec {
  version = "4.14.38";

  # branchVersion needs to be x.y
  extraMeta.branch = concatStrings (intersperse "." (take 2 (splitString "." version)));

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "00ibrl633d4cqnn4i0z7kj1ddj1243dh7ap783bwlicw9hkddwzg";
  };
} // (args.argsOverride or {}))
