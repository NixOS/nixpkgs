{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, libre ? false, ... } @ args:

buildLinux (args // rec {
  version = "4.4.121" + (if libre then "-gnu" else "");
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = if !libre
          then "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz"
          else "https://www.linux-libre.fsfla.org/pub/linux-libre/releases/${version}/linux-libre-${version}.tar.xz";
    sha256 = if !libre
             then "0ad7djpbwapk126jddrnnq0a5a9mmhrr36qcnckc7388nml85a24"
             else "1d7djrhiib0ds9ssjkali6b5w6rzap4zgj5hf9jq1jmqpp54jkm4";
  };
} // (args.argsOverride or {}))
