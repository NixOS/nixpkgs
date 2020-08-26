{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.234";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "123354h05fip161rzlxc8h0cn5lh0d1gz06gc5b7zyz9i2lxv539";
  };
} // (args.argsOverride or {}))
