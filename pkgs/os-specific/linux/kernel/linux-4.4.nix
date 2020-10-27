{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

with stdenv.lib;

buildLinux (args // rec {

  version = "4.4.240";
  extraMeta = { branch = versions.majorMinor version; } // (args.extraMeta or {});

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "131pamgxxmx4ba4gn2qxczv8w3lxrmwlqg0a7pdjzg0sy9lirygk";
  };
} // (args.argsOverride or {}))
