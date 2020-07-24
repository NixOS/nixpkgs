{ callPackage, openssl, icu67, python3, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl;
    icu = icu67;
    python = python3;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "14.6.0";
    sha256 = "153a07ffrmvwbsc78wrc0xnwymmzrhva0kn6mgnfi3086v3h1wss";
  }
