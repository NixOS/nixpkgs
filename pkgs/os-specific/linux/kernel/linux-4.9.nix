{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.122";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0v7qdkdlgpv83v4lzm59jgaxy1l7dzkqjr3fcahqrnrcdf3r0vx4";
  };
} // (args.argsOverride or {}))
