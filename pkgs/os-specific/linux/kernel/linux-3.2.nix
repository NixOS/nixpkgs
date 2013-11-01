{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "3.2.52";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/linux-${version}.tar.xz";
    sha256 = "1wpr5xs6vg0xjlzrlbkv7bjvv34psw57crkdh4lybghi4rgrmkzl";
  };

  features.iwlwifi = true;
})
