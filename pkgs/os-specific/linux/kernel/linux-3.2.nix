{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "3.2.50";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/linux-${version}.tar.xz";
    sha256 = "0yg936syhay9x0qxqxdqrgi6ijdqklhqdrd8zk7l4zvgxaayaj68";
  };

  features.iwlwifi = true;
})
