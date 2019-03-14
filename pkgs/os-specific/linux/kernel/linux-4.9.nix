{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.163";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "14gggqk3viy5wwdl51bskvvjdxv928yb8x4ymdsi5f8p5jbgjz62";
  };
} // (args.argsOverride or {}))
