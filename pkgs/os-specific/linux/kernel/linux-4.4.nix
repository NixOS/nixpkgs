{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.137";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "01hjnwfrx0fr9zbd6qcqfxsp0xm34ai7k49i7ndxwcrhzdipkl9i";
  };
} // (args.argsOverride or {}))
