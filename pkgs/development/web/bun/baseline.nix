{ callPackage, fetchurl }:

let
  buildBun = callPackage ./bun.nix { };
in
buildBun rec {
  version = "1.1.8";
  sources = {
    "x86_64-darwin" = fetchurl {
      url = "https://github.com/oven-sh/bun/releases/download/bun-v${version}/bun-darwin-x64-baseline.zip";
      hash = "sha256-CrlpB6SJaNTOaPUaHglAL4BB/WMfG6BKcI3qKM0zxTk=";
    };
    "x86_64-linux" = fetchurl {
      url = "https://github.com/oven-sh/bun/releases/download/bun-v${version}/bun-linux-x64-baseline.zip";
      hash = "sha256-1n5BuxbJo/qd8YLNeKem60R+y7TrDmt48SyQ3YvmElI=";
    };
  };
}
