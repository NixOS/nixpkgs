{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "3.2.60";
  extraMeta.branch = "3.2";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/linux-${version}.tar.xz";
    sha256 = "10nigsr0i08ykmkbalsjm4v283iy42zxgxxl77h6484xxb52bw7s";
  };

  features.iwlwifi = true;
} // (args.argsOverride or {}))
