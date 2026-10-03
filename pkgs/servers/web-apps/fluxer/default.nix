{ callPackage, ... }:
{
  admin = callPackage ./admin.nix { };
  api = callPackage ./api.nix { };
  app-proxy = callPackage ./app-proxy.nix { };
  gateway = callPackage ./gateway.nix { };
  gifs = callPackage ./gifs.nix { };
  media-proxy = callPackage ./media-proxy.nix { };
  messages = callPackage ./messages.nix { };
  push = callPackage ./push.nix { };
  snowflakes = callPackage ./snowflakes.nix { };
  static = callPackage ./static.nix { };
  users = callPackage ./users.nix { };
}
