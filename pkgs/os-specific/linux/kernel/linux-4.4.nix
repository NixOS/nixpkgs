{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.168";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0zhmhccwki1r7p99ap772p3bknl4hm6zfwvzk97nas42anqc0ylg";
  };
} // (args.argsOverride or {}))
