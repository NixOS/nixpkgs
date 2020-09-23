{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.237";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "07w6mwgh7i3bvg1w3w5i9kgxjmvqr7cv7nzrmx7j9p6cq295gv41";
  };
} // (args.argsOverride or {}))
