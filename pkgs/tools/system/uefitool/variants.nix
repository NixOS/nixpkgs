{ callPackage }:
{
  new-engine = callPackage ./new-engine.nix { };
  old-engine = callPackage ./old-engine.nix { };
}
