{ callPackage, openssl, icu, python2, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl icu;
    python = python2;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "12.19.0";
    sha256 = "1qainpkakkl3xip9xz2wbs74g95gvc6125cc05z6vyckqi2iqrrv";
  }
