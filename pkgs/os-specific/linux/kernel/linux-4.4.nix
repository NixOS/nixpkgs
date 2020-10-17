{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.240";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "131pamgxxmx4ba4gn2qxczv8w3lxrmwlqg0a7pdjzg0sy9lirygk";
  };
} // (args.argsOverride or {}))
