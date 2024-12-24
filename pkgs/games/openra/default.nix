{ callPackage }:

let
  buildOpenRAEngine = callPackage ./build-engine.nix { };
  callPackage' = path: callPackage path { inherit buildOpenRAEngine; };
in
{
  engines = {
    release = callPackage' ./engines/release;
    devtest = callPackage' ./engines/devtest;
  };
}
