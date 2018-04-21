{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.128";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1c5nlxazn2ijfra1bn3x4fdz3fx02j76hg430jgyij61vndgi5ka";
  };
} // (args.argsOverride or {}))
