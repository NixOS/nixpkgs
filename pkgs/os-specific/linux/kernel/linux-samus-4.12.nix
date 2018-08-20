{ stdenv, buildPackages, fetchFromGitHub, perl, buildLinux, ncurses, ... } @ args:

buildLinux (args // rec {
  version = "4.12.2";
  extraMeta.branch = "4.12-2";

  src =
    let upstream = fetchFromGitHub {
      owner = "raphael";
      repo = "linux-samus";
      rev = "v${extraMeta.branch}";
      sha256 = "1dr74i79p8r13522w2ppi8gnjd9bhngc9d2hsn91ji6f5a8fbxx9";
    }; in "${upstream}/build/linux";

  extraMeta.platforms = [ "x86_64-linux" ];
} // (args.argsOverride or {}))
