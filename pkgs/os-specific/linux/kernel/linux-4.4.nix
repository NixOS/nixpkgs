{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.152";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1jyky74cbaz76x5bpkgw3d45kim3y8brnjp854qkx8462s4pdvhv";
  };
} // (args.argsOverride or {}))
