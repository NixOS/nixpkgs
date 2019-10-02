{ callPackage, openssl, icu, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix { inherit openssl icu; };
in
  buildNodejs {
    inherit enableNpm;
    version = "12.11.1";
    sha256 = "1vi4xj7gg4g7pkhnj9cwzy8gbyg3mq5z6ljqi7z392mbhmwvqgz5";
  }
