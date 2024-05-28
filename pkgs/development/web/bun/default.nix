{ callPackage, fetchurl }:

let
  buildBun = callPackage ./bun.nix { };
in
buildBun rec {
  version = "1.1.9";
  sources = {
    "aarch64-darwin" = fetchurl {
      url = "https://github.com/oven-sh/bun/releases/download/bun-v${version}/bun-darwin-aarch64.zip";
      hash = "sha256-gk3Zi8AcpMTCexL8ASY29W2LcwYICpD2QwpvuEbQpB4=";
    };
    "aarch64-linux" = fetchurl {
      url = "https://github.com/oven-sh/bun/releases/download/bun-v${version}/bun-linux-aarch64.zip";
      hash = "sha256-F5yfovHAsWeLiQ4Uigrm0hy3gwz8pK5PA6AuZiyrfOI=";
    };
    "x86_64-darwin" = fetchurl {
      url = "https://github.com/oven-sh/bun/releases/download/bun-v${version}/bun-darwin-x64.zip";
      hash = "sha256-HV8iVZwHPPyini8rCVMnSHmqL7HUM27uOSfaTcdnnZ0=";
    };
    "x86_64-linux" = fetchurl {
      url = "https://github.com/oven-sh/bun/releases/download/bun-v${version}/bun-linux-x64.zip";
      hash = "sha256-yIz/CWKTSKoeOTb/2rxbyYovw0rralSj0r2ZMPu29i8=";
    };
  };
}
