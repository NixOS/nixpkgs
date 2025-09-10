{ callPackage }:

let
  openRaUpdater = callPackage ./updater.nix { };
  buildOpenRAEngine = callPackage ./build-engine.nix { inherit openRaUpdater; };
  callPackage' = path: callPackage path { inherit buildOpenRAEngine; };
in
{
  engines = {
    release = callPackage' ./engines/release;
    bleed = callPackage' ./engines/bleed;
  };
}
