{ callPackage, openssl, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix { inherit openssl; };
in
  buildNodejs {
    inherit enableNpm;
    version = "10.18.0";
    sha256 = "1ppycqffsy7ix6whdp6id7ld1qizwvjlzxyk12kxw4wphjmn49hb";
  }
