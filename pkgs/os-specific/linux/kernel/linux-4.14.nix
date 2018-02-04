{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

with stdenv.lib;

import ./generic.nix (args // rec {
  version = "4.14.17";

  # branchVersion needs to be x.y
  extraMeta.branch = concatStrings (intersperse "." (take 2 (splitString "." version)));

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0jqa86bnnlzv0r0bvzvmbj1c89a5m64zrjfvfrjlwg3vy63r9ii7";
  };
} // (args.argsOverride or {}))
