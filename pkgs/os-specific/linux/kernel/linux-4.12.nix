{ stdenv, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.12.14";
  extraMeta.branch = "4.12";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "09zxmknh6awhqmj8dyq95bdlwcasryy35hkjxjlzixdgn52kzaw6";
  };
} // (args.argsOverride or {}))
