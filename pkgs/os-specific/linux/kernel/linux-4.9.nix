{ buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.253";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "065w35vb0qp4fvnwmcx7f92inmx64f9r04zzwcwbs0826nl52nws";
  };
} // (args.argsOverride or {}))
