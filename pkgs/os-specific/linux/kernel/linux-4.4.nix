{ buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.255";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0l45csywd30qrs8gwzjjijr5hwpd5s05rbyrxb37vck78znk0f1g";
  };
} // (args.argsOverride or {}))
