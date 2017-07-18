{ stdenv, fetchFromGitHub, perl, buildLinux, ncurses, ... } @ args:

assert stdenv.is64bit;

import ./generic.nix (args // rec {
  version = "4.11.1";
  extraMeta.branch = "4.11-2";

  src =
    let upstream = fetchFromGitHub {
      owner = "raphael";
      repo = "linux-samus";
      rev = "v${extraMeta.branch}";
      sha256 = "0b95mzadz8jd4pzizgdz6rkli1lh83kdc1zyrs44yin0xg9phxy4";
    }; in "${upstream}/build/linux";

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.netfilterRPFilter = true;

  extraMeta.hydraPlatforms = [];
} // (args.argsOverride or {}))
