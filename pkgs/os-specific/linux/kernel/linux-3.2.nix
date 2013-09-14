{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "3.2.51";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/linux-${version}.tar.xz";
    sha256 = "1x1yk07ihfbrhsycmd44h9fn6ajg6akwgsxxdi2rk5cs8g706s63";
  };

  features.iwlwifi = true;
})
