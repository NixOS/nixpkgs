{ callPackage, openssl, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix { inherit openssl; };
in
  buildNodejs {
    inherit enableNpm;
    version = "10.18.1";
    sha256 = "0dgax08lkgjvafp6i0c5h8wqqs0w49j8mh8fqi6ppbrryhviibrr";
  }
