{ callPackage, ccextractor }:

{
  server = callPackage ./server.nix { inherit ccextractor; };
  node = callPackage ./node.nix { };
}
