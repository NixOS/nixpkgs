{ buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.257";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0kynyqk62hkfmamhvfp98i9kyr395chnwghslcbq5pl1zkzq1rwm";
  };
} // (args.argsOverride or {}))
