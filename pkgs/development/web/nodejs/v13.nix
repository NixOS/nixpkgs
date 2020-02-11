{ callPackage, openssl, icu, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix { inherit openssl icu; };
in
  buildNodejs {
    inherit enableNpm;
    version = "13.8.0";
    sha256 = "1h437yvg43xci35rvp55gvb94rddkf4j9i9iw81bmkwhvb4h8qdv";
  }
