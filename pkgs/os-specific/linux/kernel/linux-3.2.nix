{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "3.2.49";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/linux-${version}.tar.xz";
    sha256 = "06xiwcgk6hbcp6g1dpmxb95dzx94s29vzmh1pz4lsglcj1yfrkry";
  };

  features.iwlwifi = true;
})
