{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.151";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1s49h2my2jysh1i38vygqlcj9bz8fzg6vsv9k3ln3pi6hqqqrsjz";
  };
} // (args.argsOverride or {}))
