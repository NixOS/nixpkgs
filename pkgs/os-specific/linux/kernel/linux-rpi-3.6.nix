{ stdenv, fetchurl, ... } @ args:

let rev = "91a3be5b2b"; in

import ./generic.nix (args // rec {
  version = "3.6.y-${rev}";

  src = fetchurl {
    url = "https://api.github.com/repos/raspberrypi/linux/tarball/${rev}";
    name = "linux-raspberrypi-${version}.tar.gz";
    sha256 = "04370b1da7610622372940decdc13ddbba2a58c9da3c3bd3e7df930a399f140d";
  };

  features.iwlwifi = true;

  extraMeta.platforms = [];
})
