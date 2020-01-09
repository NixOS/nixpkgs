{ callPackage, openssl, icu, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix { inherit openssl icu; };
in
  buildNodejs {
    inherit enableNpm;
    version = "13.6.0";
    sha256 = "0jf9nn5i1bijmrcgjvkp37fyz63lwwmxjh7nxipn2vw2qdx6ngsm";
  }
