{ callPackage, ... }:
{
  admin = callPackage ./admin.nix { };
  api = callPackage ./api.nix { };
  app-proxy = callPackage ./app-proxy.nix { };
  gateway = callPackage ./gateway.nix { };
  media-proxy = callPackage ./media-proxy.nix { };
  push = callPackage ./push.nix { };
}
