{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.220";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1knj3qsl7x3fysdz1h0s980ddbafs3658z2y67w6sn79wp7d8blg";
  };
} // (args.argsOverride or {}))
