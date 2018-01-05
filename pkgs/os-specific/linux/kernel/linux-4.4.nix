{ stdenv, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.4.110";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0n6v872ahny9j29lh60c7ha5fa1as9pdag7jsb5fcy2nmid1g6fh";
  };
} // (args.argsOverride or {}))
