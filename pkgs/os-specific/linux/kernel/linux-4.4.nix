{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.227";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "196x57w740firg8zchypq4vq6a83ymmwn9amqrscym9zr0pcgm40";
  };
} // (args.argsOverride or {}))
