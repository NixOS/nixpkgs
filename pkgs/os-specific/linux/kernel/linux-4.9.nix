{ stdenv, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.9.54";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1i8g44d3mq7c24mn6b5w59d2z3fxjzbfn5blc36lzkpvdvdha435";
  };
} // (args.argsOverride or {}))
