{ stdenv, hostPlatform, fetchFromGitHub, perl, buildLinux, ncurses, ... } @ args:

assert stdenv.is64bit;

import ./generic.nix (args // rec {
  version = "4.12.2";
  extraMeta.branch = "4.12-2";

  src =
    let upstream = fetchFromGitHub {
      owner = "raphael";
      repo = "linux-samus";
      rev = "v${extraMeta.branch}";
      sha256 = "1dr74i79p8r13522w2ppi8gnjd9bhngc9d2hsn91ji6f5a8fbxx9";
    }; in "${upstream}/build/linux";

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.netfilterRPFilter = true;

  extraMeta.hydraPlatforms = [];
} // (args.argsOverride or {}))
