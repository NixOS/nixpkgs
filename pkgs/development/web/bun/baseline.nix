{ callPackage, fetchurl }:

let
  buildBun = callPackage ./bun.nix { };
in
buildBun rec {
  version = "1.1.9";
  sources = {
    "x86_64-darwin" = fetchurl {
      url = "https://github.com/oven-sh/bun/releases/download/bun-v${version}/bun-darwin-x64-baseline.zip";
      hash = "sha256-gjW8ThpVBOdyxZT/MzVHTQBs2zlH+Uy/CJKKbgytITo=";
    };
    "x86_64-linux" = fetchurl {
      url = "https://github.com/oven-sh/bun/releases/download/bun-v${version}/bun-linux-x64-baseline.zip";
      hash = "sha256-LeFSi6gtUsqd0ljapRRt0Rb353kVqmfYNmIqfDPU3eg=";
    };
  };
}
