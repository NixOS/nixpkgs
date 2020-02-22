{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.214";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0v575wl85fg9c3ksdj570hxjcl9p1dxwzag3fm0qcrq75kp6bamn";
  };
} // (args.argsOverride or {}))
