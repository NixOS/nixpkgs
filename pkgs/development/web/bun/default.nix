{ callPackage, fetchurl }:

let
  buildBun = callPackage ./bun.nix { };
in
buildBun rec {
  version = "1.1.8";
  sources = {
    "aarch64-darwin" = fetchurl {
      url = "https://github.com/oven-sh/bun/releases/download/bun-v${version}/bun-darwin-aarch64.zip";
      hash = "sha256-n5ElTDuD0fap+llzrXN7de937jYaAG8dpJlKUB0npT4=";
    };
    "aarch64-linux" = fetchurl {
      url = "https://github.com/oven-sh/bun/releases/download/bun-v${version}/bun-linux-aarch64.zip";
      hash = "sha256-4/kEyaF2kmu8MAjlrPgBqKFDId8bBibu3Zll3b0w8Ro=";
    };
    "x86_64-darwin" = fetchurl {
      url = "https://github.com/oven-sh/bun/releases/download/bun-v${version}/bun-darwin-x64.zip";
      hash = "sha256-btyslaKqdk86whAnQV0on7NWTBTRTegFvMsOl0YyloY=";
    };
    "x86_64-linux" = fetchurl {
      url = "https://github.com/oven-sh/bun/releases/download/bun-v${version}/bun-linux-x64.zip";
      hash = "sha256-JuDT+8FHbamdMVCDeSTGPYOvhPY2EZ9XeD2zjHEj36Y=";
    };
  };
}
