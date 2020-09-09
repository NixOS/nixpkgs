{ callPackage, openssl, icu, python2, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix { 
    inherit openssl icu;
    python = python2;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "12.18.3";
    sha256 = "03hdds6ghlmbz8q61alqj18pdnyd6hxmbhiws4pl51wlawk805bi";
  }
