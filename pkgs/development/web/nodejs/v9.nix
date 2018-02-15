{ stdenv, callPackage, lib, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {};
in
  buildNodejs {
    inherit enableNpm;
    version = "9.5.0";
    sha256 = "0v8lspfca820mf45dj9hb56q00syhrqw5wmqmy1vnrcb6wx4csv6";
    patches = lib.optionals stdenv.isDarwin [ ./no-xcode-v7.patch ];
  }
