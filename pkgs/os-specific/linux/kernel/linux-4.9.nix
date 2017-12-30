{ stdenv, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.9.73";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0avfq79fn8rfjbn24wfr9pz438qvwm8vdm3si4fl4v3d7z2nb2sm";
  };
} // (args.argsOverride or {}))
