{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.124";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0a91phmdpa82s3mqnyw2an3j4v18cksvy1akdyxf5w2byq51qd2r";
  };
} // (args.argsOverride or {}))
