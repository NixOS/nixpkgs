{ callPackage, openssl, python3, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl;
    python = python3;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "16.1.0";
    sha256 = "0z0808mw674mshgbmhgngqfkrdix3b61f77xcdz7bwf1j87j7ad0";
  }
