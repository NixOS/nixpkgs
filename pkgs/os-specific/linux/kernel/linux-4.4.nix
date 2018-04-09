{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.126";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0n6dk6pdaf5bsgfr1vkv2xy2zhgrnffrgnivqpkj94d8rp2g9j79";
  };
} // (args.argsOverride or {}))
