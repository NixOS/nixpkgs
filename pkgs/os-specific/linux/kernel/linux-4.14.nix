{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

with stdenv.lib;

buildLinux (args // rec {
  version = "4.14.27";

  # branchVersion needs to be x.y
  extraMeta.branch = concatStrings (intersperse "." (take 2 (splitString "." version)));

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1si8l3clpkyhwawrjxz6yzx7xl0v0k6dy1yf5qiwf1hsqx4s8489";
  };
} // (args.argsOverride or {}))
