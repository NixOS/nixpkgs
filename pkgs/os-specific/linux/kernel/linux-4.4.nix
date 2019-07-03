{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.184";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1jn3mwnfcvhnn0bqiyabkqii3rd6w5b982w3i085qj42q0pj6hv5";
  };
} // (args.argsOverride or {}))
