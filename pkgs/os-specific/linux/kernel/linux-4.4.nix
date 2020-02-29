{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.215";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "00zy6cxwb16pqziiqs25pz5llryx2v2nbk9vvzpzxa8x43ad7g18";
  };
} // (args.argsOverride or {}))
