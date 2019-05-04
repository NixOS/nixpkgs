{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.173";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0s0iypddxqkabjmd72frfk6dca8amk46vmiyy2nh8zbx9y89smxw";
  };
} // (args.argsOverride or {}))
