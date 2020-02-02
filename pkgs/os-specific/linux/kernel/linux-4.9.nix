{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.212";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0c5yjilaq86j6i2hzlxbp2ia7jhnf7kv952ffv7jxdf90sk3irxd";
  };
} // (args.argsOverride or {}))
