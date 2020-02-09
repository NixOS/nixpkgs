{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.213";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1cmwn9zvz14jqjy6qkszglhs2p5h6yh82b2269cbzvibg8y3rxq0";
  };
} // (args.argsOverride or {}))
