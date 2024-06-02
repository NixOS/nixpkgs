{ callPackage, fetchurl }:

let
  buildBun = callPackage ./bun.nix { };
in
buildBun rec {
  version = "1.1.10";
  sources = {
    "x86_64-darwin" = fetchurl {
      url = "https://github.com/oven-sh/bun/releases/download/bun-v${version}/bun-darwin-x64-baseline.zip";
      hash = "sha256-We4eENZtGmxv47y9p9dvmbNHbUUW5WubHT/HwTUUajU=";
    };
    "x86_64-linux" = fetchurl {
      url = "https://github.com/oven-sh/bun/releases/download/bun-v${version}/bun-linux-x64-baseline.zip";
      hash = "sha256-hWqAMCCifKIdn8nAoTRX+E49XYIxbyoGHcK09TQT6B0=";
    };
  };
}
