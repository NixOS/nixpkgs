{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.90";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0mbl0d6z8yx7bn5m804kv17bh64pd0w0nc8lls4pw335jx7hkc0v";
  };
} // (args.argsOverride or {}))
