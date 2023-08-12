{ rust, stdenv, fetchurl }:

let
  arch = rust.toRustTarget stdenv.hostPlatform;
  fetch_librusty_v8 = args: fetchurl {
    name = "librusty_v8-${args.version}";
    url = "https://github.com/denoland/rusty_v8/releases/download/v${args.version}/librusty_v8_release_${arch}.a";
    sha256 = args.shas.${stdenv.hostPlatform.system};
    meta = { inherit (args) version; };
  };
in
fetch_librusty_v8 {
  version = "0.68.0";
  shas = {
    x86_64-linux = "sha256-yq7YPD2TM6Uw0EvCqIsZ/lbE1RLgIg7a42qDVrr5fX4=";
    aarch64-linux = "sha256-uZFm3hAeyEUUXqRJFLM3OBVfglH3AecjFKVgeJZu3L0=";
    x86_64-darwin = "sha256-YkxoggK0I4rT/KNJ30StDPLUc02Mdjwal3JH+s/YTQo=";
    aarch64-darwin = "sha256-aXE7W3sSzbhvC661BYTTHyHlihmVVtFSv85nSjGOLkU=";
  };
}
