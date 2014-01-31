{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "3.13.1";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/linux-${version}.tar.xz";
    sha256 = "0gkikbz676h79rv0aaihl90mw7fqhjx3rkhcqrmzggjb54048jvq";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;
})
