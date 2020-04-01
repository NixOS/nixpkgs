{ callPackage, openssl, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix { inherit openssl; };
in
  buildNodejs {
    inherit enableNpm;
    version = "10.19.0";
    sha256 = "0sginvcsf7lrlzsnpahj4bj1f673wfvby8kaxgvzlrbb7sy229v2";
  }
