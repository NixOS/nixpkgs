{ stdenv, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.4.105";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0h0ivdw74m3s2j9llh0hnigv790jgy6lhcf6jn2csxmvg3ai5sfn";
  };
} // (args.argsOverride or {}))
