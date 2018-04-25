{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.96";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0zw7x86c8qa2kzkwlxlhqzsnddyp1ncw4ja660bqnzqrnmp5jvw2";
  };
} // (args.argsOverride or {}))
