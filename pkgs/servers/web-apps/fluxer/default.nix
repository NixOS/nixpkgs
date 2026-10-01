{ callPackage, ... }:
{
  admin = callPackage ./admin.nix { };
  api = callPackage ./api.nix { };
  app-proxy = callPackage ./app-proxy.nix { };
}
