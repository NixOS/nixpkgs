{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.142";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0zyxlqjnxrr1a1wlg3hzk8sx77ysmy66wb34kp77iv04xr9p9kai";
  };
} // (args.argsOverride or {}))
