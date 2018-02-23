{ stdenv, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.9.83";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1csh557b9b0zsldlk1lalmy5wgn5rhk857fryn3v4nh8kj3y4mw9";
  };
} // (args.argsOverride or {}))
