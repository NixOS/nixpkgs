{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.147";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "10hxxcwa9lgsdz0k6229fly9r7iyqv9xq838zx8s7bd12qrrfb59";
  };
} // (args.argsOverride or {}))
