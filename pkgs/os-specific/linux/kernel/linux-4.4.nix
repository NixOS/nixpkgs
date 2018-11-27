{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.165";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "19zmigb1avq63n0cbvsqaw9ygddwx13mrvl80p92abw7ns26b2va";
  };
} // (args.argsOverride or {}))
