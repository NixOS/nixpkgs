{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "3.2.56";
  extraMeta.branch = "3.2";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/linux-${version}.tar.xz";
    sha256 = "08858sx63bsay185ywwyh01wnms7lyh9rvgwznwnzmjpnfi3hihm";
  };

  features.iwlwifi = true;
} // (args.argsOverride or {}))
