{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.211";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1f6qz4bvjn18cfcg3wwfsl75aw2kxwn28r228kdic9aibhy6rpvp";
  };
} // (args.argsOverride or {}))
