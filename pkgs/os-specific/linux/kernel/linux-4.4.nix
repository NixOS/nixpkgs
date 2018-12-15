{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.167";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1pryjpih8js9640jhv74wzvka4199irnp7bzn33lyh35lll4rjik";
  };
} // (args.argsOverride or {}))
