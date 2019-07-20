{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.185";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1ll694m5193dmwn8ys4sf2p6a6njd5pm38v862ih1iw7l3vj0l3s";
  };
} // (args.argsOverride or {}))
