{ callPackage, ... }:
let
  fluxerHashes = {
    rev = "83bb9d89c8f24f1975ee3a3e4c8c9ddb38d53929";
    version = "2026.1010.xxx";
    hash = "sha256-Vw988gKlwT/c83A5B4T2pgCso4Peq9zOrUmeQTND3F0=";
    cargo.hash = "sha256-LBbkzQ3FBR0WBgDT8+DZWgX+7hyFQf0FgnlzSWY8ifc=";
    cargo.lib.fluxcore = "sha256-n9hA0WaUyYpXV9ply8QwUgq4NvmBERIebrfzz2lCd/A=";
    cargo.lib.fluxwebp = "sha256-zz5JD3jiNCx8FOReZmCm4O2F20s7UbMsfZIM2sIcSS0=";
    cargo.lib.guildMemberListNif = "sha256-lECOMdkbdWAeL829MrWPWGQI44P+4VMnLIp9Jd+xJJo=";
    cargo.lib.pushMarkdownPlaintext = "sha256-9HDcMd1qfIOJPIw6D9bLR4rSfbz8Zv/wz9zQe3PoZjM=";
    pnpm.appProxy = "sha256-/CrJW3DyRkMm3HVSw8wBD/SnK9odbNg6p1mlhKF7KjE=";
    pnpm.api = "sha256-vrBibeznQIJyMA/56p/5IM3pdnURR6XOjhCRvxZcDng=";
    rebar = "sha256-rGSvSCUjH+BedJga2Kq2B7diDT5M68l2xmp9hbDD5xI=";
  };
in
{
  admin = callPackage ./admin.nix { inherit fluxerHashes; };
  api = callPackage ./api.nix { inherit fluxerHashes; };
  app-proxy = callPackage ./app-proxy.nix { inherit fluxerHashes; };
  gateway = callPackage ./gateway.nix { inherit fluxerHashes; };
  gifs = callPackage ./gifs.nix { inherit fluxerHashes; };
  media-proxy = callPackage ./media-proxy.nix { inherit fluxerHashes; };
  messages = callPackage ./messages.nix { inherit fluxerHashes; };
  push = callPackage ./push.nix { inherit fluxerHashes; };
  snowflakes = callPackage ./snowflakes.nix { inherit fluxerHashes; };
  static = callPackage ./static.nix { inherit fluxerHashes; };
  unfurl = callPackage ./unfurl.nix { inherit fluxerHashes; };
  users = callPackage ./users.nix { inherit fluxerHashes; };
}
