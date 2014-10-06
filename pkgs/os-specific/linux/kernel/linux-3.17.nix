{ stdenv, fetchurl, ... } @ args:

import ./generic.nix (args // rec {
  version = "3.17";
  modDirVersion = "3.17.0";
  extraMeta.branch = "3.17";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v3.x/linux-${version}.tar.xz";
    sha256 = "0lb2yyh3j932789jq4gxx9xshgy6rfdnl3lm8yr43kaz7k4kw5gm";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.canDisableNetfilterConntrackHelpers = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
