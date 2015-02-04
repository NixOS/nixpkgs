{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "3.2.66";
  extraMeta.branch = "3.2";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/linux-${version}.tar.xz";
    sha256 = "09l0rfv10c5kzlgfhi339ly496f6j9ichq3arpvkb3fivjkxcm45";
  };

  features.iwlwifi = true;
} // (args.argsOverride or {}))
