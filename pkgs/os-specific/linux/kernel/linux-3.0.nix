{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "3.0.99";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/linux-${version}.tar.xz";
    sha256 = "1p31gq9kzwfks980y6rb2mjyagj8lrh6y156a550v7mk0bd4fzdi";
  };

  features.iwlwifi = true;
})
