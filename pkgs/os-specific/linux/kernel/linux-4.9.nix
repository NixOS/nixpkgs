{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.95";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1x4z66v6zl4q0hzinzb1wvlq9fd3v4sbwj9lay69f3vdq8knsnly";
  };
} // (args.argsOverride or {}))
