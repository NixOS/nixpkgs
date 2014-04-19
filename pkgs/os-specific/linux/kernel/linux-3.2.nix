{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "3.2.57";
  extraMeta.branch = "3.2";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/linux-${version}.tar.xz";
    sha256 = "0njiqa5fi82a4dls9z1cp33lza00bg15x93c19bsyalp53xqbnab";
  };

  features.iwlwifi = true;
} // (args.argsOverride or {}))
