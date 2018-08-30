{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.153";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "00jlajwbq7w5cxzzaa5mib5qvihqab3ysfq401b71ji2bi8ma8qg";
  };
} // (args.argsOverride or {}))
