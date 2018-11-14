{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.163";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1x1fixnz41q6pq1cms9z48mrac984r675m94fdm08m8ajqxddcv1";
  };
} // (args.argsOverride or {}))
