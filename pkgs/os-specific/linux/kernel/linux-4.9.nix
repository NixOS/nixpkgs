{ buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.263";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1dhmgyg6asqg1pmhnzqymwz4bm6gy8gi0n2gr794as38dhn2szwz";
  };
} // (args.argsOverride or {}))
