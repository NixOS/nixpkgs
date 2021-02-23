{ buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.258";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1kf8wlcf8gkpnglx1ggn1c3xfz4yx9995yb919mvin7nd7hghy6l";
  };
} // (args.argsOverride or {}))
