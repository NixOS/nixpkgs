{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "3.2.62";
  extraMeta.branch = "3.2";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/linux-${version}.tar.xz";
    sha256 = "1yrmar14p5y9xaj9df388xwjmwz8fnsxnid6rkxxk7dni5di8nqf";
  };

  features.iwlwifi = true;
} // (args.argsOverride or {}))
