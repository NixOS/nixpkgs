{ stdenv, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.9.80";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0ys74q9f93c42flqracaqnkh0qwcbnimhppd80rz5hxgq3686bly";
  };
} // (args.argsOverride or {}))
