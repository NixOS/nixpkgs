{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.93";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "00srda6plvirmrr0bjgiksf00ssiigf5cqi4giy4mij5r6v8mxsq";
  };
} // (args.argsOverride or {}))
