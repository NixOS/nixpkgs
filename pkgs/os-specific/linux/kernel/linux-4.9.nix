{ buildPackages, fetchurl, perl, buildLinux, nixosTests, stdenv, ... } @ args:

buildLinux (args // rec {
  version = "4.9.304";
  extraMeta.branch = "4.9";
  extraMeta.broken = stdenv.isAarch64;

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "099bkypbkb8an8jsl49f83kg6ic1yw9ssfc1qksaji1jparlnpi9";
  };
} // (args.argsOverride or {}))
