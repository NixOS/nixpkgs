{ callPackage, ... }:
{
  admin = callPackage ./admin.nix { };
  api = callPackage ./api.nix { };
}
